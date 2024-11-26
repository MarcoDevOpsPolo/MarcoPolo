#!/bin/bash

vpcId=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=my-vpc-stemilia" --query "Vpcs[0].VpcId" --output text)
igwId=$(aws ec2 describe-internet-gateways --filters "Name=tag:Name,Values=my-igw-stemilia" --query "InternetGateways[0].InternetGatewayId" --output text)

aws ec2 attach-internet-gateway \
    --internet-gateway-id "$igwId" \
    --vpc-id "$vpcId"