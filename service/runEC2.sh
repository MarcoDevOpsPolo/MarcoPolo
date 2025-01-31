#!/bin/bash
subnetName="$1"
vpcId="$2"
keyName="$3"    # personal key name
imageID="$4"    # ami id
instanceName="$5"

subnetID=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpcId" "Name=tag:Name,Values=$subnetName" --query "Subnets[0].SubnetId" --output text)
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
if [[ "$subnetName" == *"public"* ]]; then
    runInstanceCmd="$runInstanceCmd \
        --associate-public-ip-address \
        --tag-specifications \"ResourceType=instance,Tags=[{Key=Name,Value=$instanceName}]\""
else
    runInstanceCmd="$runInstanceCmd \
    --tag-specifications \"ResourceType=instance,Tags=[{Key=Name,Value=$instanceName}]\""
fi

# Run the command
eval "$runInstanceCmd" >> /dev/null