#!/bin/bash

vpcId="$1"

rtId=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$vpcId" --query "RouteTables[0].RouteTableId" --output text
)

aws ec2 create-tags --resources "$rtId" --tags Key=Name,Value=my-private-rt-stemilia
