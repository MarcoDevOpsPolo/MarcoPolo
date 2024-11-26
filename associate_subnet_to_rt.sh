#!/bin/bash
vpcId=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=my-vpc-stemilia" --query "Vpcs[0].VpcId" --output text)
subnetId=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpcId" "Name=tag:Name,Values=my-private-subnet-stemilia" --query "Subnets[0].SubnetId" --output text)
rtId=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$vpcId" --query "RouteTables[0].RouteTableId" --output text)

aws ec2 associate-route-table --route-table-id "$rtId" --subnet-id "$subnetId"