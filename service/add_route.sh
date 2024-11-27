#!/bin/bash

rtNamePart="$1"

# Get the VPC ID
vpcId="$2"

# Get the Route Table ID
rtId=$(aws ec2 describe-route-tables \
  --filters "Name=vpc-id,Values=$vpcId" "Name=tag:Name,Values=my-$rtNamePart-rt-stemilia" \
  --query "RouteTables[0].RouteTableId" \
  --output text)

# Prepare base command for adding a route
addroutecmd="aws ec2 create-route --route-table-id \"$rtId\" --destination-cidr-block 0.0.0.0/0"

# Check whether to use Internet Gateway or NAT Gateway
if [[ "$rtNamePart" == "public" ]]; then
  igwId=$(aws ec2 describe-internet-gateways \
    --filters "Name=tag:Name,Values=my-igw-stemilia" \
    --query "InternetGateways[0].InternetGatewayId" \
    --output text)
  addroutecmd="$addroutecmd --gateway-id $igwId"
else
  natgwId=$(aws ec2 describe-nat-gateways \
    --query "NatGateways[0].NatGatewayId" \
    --output text)
  addroutecmd="$addroutecmd --gateway-id $natgwId"
fi

# Execute the final command
eval "$addroutecmd" >> /dev/null
