#!/bin/bash
vpcId="$1"
secGroupId=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=default" "Name=vpc-id,Values=$vpcId" --query "SecurityGroups[0].GroupId" --output text)

aws ec2 authorize-security-group-ingress \
  --group-id "$secGroupId" \
  --protocol tcp \
  --port 22 \
  --cidr 0.0.0.0/0 >> /dev/null

