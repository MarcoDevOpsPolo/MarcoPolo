#!/bin/bash

vpcId=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=my-vpc-stemilia" --query "Vpcs[0].VpcId" --output text
)

rtId=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$vpcId" --query "RouteTables[0].RouteTableId" --output text
)

aws ec2 create-tags --resources "$rtId" --tags Key=Name,Value=my-private-rt-stemilia
