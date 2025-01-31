#!/bin/bash
vpcId="$1"
rtname="$2"

aws ec2 create-route-table \
 --vpc-id "$vpcId" \
 --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=$rtname}]" >> /dev/null