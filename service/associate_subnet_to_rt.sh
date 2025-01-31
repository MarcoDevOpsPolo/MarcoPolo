#!/bin/bash
namePart="$1" #private or public
rname="$3" #default: my-rt 
sname="$4" #default: my-subnet
vpcId="$2"

subnetId=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpcId" "Name=tag:Name,Values=$namePart-$sname" --query "Subnets[0].SubnetId" --output text)
rtId=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$vpcId" "Name=tag:Name,Values=$namePart-$rname" --query "RouteTables[0].RouteTableId" --output text)

aws ec2 associate-route-table --route-table-id "$rtId" --subnet-id "$subnetId" >> /dev/null