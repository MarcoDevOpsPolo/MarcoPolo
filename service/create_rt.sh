#!/bin/bash
vpcId="$1"

aws ec2 create-route-table \
 --vpc-id "$vpcId" \
 --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=my-public-rt-stemilia}]"