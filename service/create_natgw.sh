#!/bin/bash
vpcId="$1"
subnetId=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpcId" "Name=tag:Name,Values=my-public-subnet-stemilia" --query "Subnets[0].SubnetId" --output text)


aws ec2 create-nat-gateway \
    --subnet-id "$subnetId" \
    --allocation-id "$(aws ec2 allocate-address --query "AllocationId" --output text)" \
    --tag-specifications "ResourceType=natgateway,Tags=[{Key=Name,Value=my-nat-gateway-stemilia}]" >> /dev/null