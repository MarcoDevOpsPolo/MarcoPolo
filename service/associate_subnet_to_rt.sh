#!/bin/bash
namePart="$1" #private or public
vpcId="$2"

subnetId=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpcId" "Name=tag:Name,Values=my-$namePart-subnet-stemilia" --query "Subnets[0].SubnetId" --output text)
rtId=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$vpcId" "Name=tag:Name,Values=my-$namePart-rt-stemilia" --query "RouteTables[0].RouteTableId" --output text)

aws ec2 associate-route-table --route-table-id "$rtId" --subnet-id "$subnetId" >> /dev/null