#!/bin/bash
subnetName="$1"

imageID="ami-0b5673b5f6e8f7fa7" #region: frankfurt eu-central-1
keyName="emi_rsa"    # personal key name
vpcId="$2"
subnetID=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpcId" "Name=tag:Name,Values=my-$subnetName-subnet-stemilia" --query "Subnets[0].SubnetId" --output text)
secGroupId=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=default" "Name=vpc-id,Values=$vpcId" --query "SecurityGroups[0].GroupId" --output text)

# Initialize the command
runInstanceCmd="aws ec2 run-instances \
    --image-id \"$imageID\" \
    --instance-type t2.micro \
    --count 1 \
    --subnet-id \"$subnetID\" \
    --key-name \"$keyName\" \
    --security-group-ids \"$secGroupId\""

# Conditional execution of the last two flags
if [[ "$subnetName" == "public" ]]; then
    runInstanceCmd="$runInstanceCmd \
        --associate-public-ip-address \
        --tag-specifications \"ResourceType=instance,Tags=[{Key=Name,Value=my-public-instance-stemilia}]\""
fi

# Run the command
eval "$runInstanceCmd" >> /dev/null