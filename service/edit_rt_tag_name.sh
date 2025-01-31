#!/bin/bash

vpcId="$1"
rt_name="$2"

rtId=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$vpcId" --query "RouteTables[0].RouteTableId" --output text
)

aws ec2 create-tags --resources "$rtId" --tags Key=Name,Value="$rt_name" >> /dev/null
