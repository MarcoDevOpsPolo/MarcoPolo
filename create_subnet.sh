#!/bin/bash

aws ec2 create-subnet \
    --vpc-id vpc-09baa84c21a6b6703 \
    --cidr-block 10.0.1.0/24 \
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=my-private-subnet-stemilia}]'