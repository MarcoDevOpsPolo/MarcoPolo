#!/bin/bash

vpcId="$1"
igwName="$2"
igwId=$(aws ec2 describe-internet-gateways --filters "Name=tag:Name,Values=$igwName" --query "InternetGateways[0].InternetGatewayId" --output text)

aws ec2 attach-internet-gateway \
    --internet-gateway-id "$igwId" \
    --vpc-id "$vpcId" >> /dev/null