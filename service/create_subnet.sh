#!/bin/bash
name="$1"
cidr="$2" # e.g. 10.0.1.0/24

vpcId="$3"

aws ec2 create-subnet \
    --vpc-id "$vpcId" \
    --cidr-block "$cidr" \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=$name}]" >> /dev/null