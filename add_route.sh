#!/bin/bash
vpcId=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=my-vpc-stemilia" --query "Vpcs[0].VpcId" --output text
)
igwId=$(aws ec2 describe-internet-gateways --filters "Name=tag:Name,Values=my-igw-stemilia" --query "InternetGateways[0].InternetGatewayId" --output text)
rtId=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$vpcId" "Name=tag:Name,Values=my-public-rt-stemilia" --query "RouteTables[0].RouteTableId" --output text)

aws ec2 create-route \
  --route-table-id "$rtId" \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id "$igwId"
