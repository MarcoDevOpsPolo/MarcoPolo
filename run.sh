#!/bin/bash

main() {
    ./service/create_vpc.sh 
    vpcId=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=my-vpc-stemilia" --query "Vpcs[0].VpcId" --output text)

    echo "VPC CREATED"

    #creating a Vpc will automatically generate a route-table. Let's name it private route table:
    ./service/edit_rt_tag_name.sh "$vpcId"

    echo "PRIVATE ROUTE TABLE RENAMED"

    #create private&public subnet
    ./service/create_subnet.sh my-private-subnet-stemilia 10.0.1.0/24 "$vpcId"
    ./service/create_subnet.sh my-public-subnet-stemilia 10.0.2.0/24 "$vpcId"

    echo "SUBNETS CREATED"

    #create public route table as well
    ./service/create_rt.sh "$vpcId"

    echo "PUBLIC ROUTE TABLE CREATED"

    #associate the subnets to the corresponding route tables
    ./service/associate_subnet_to_rt.sh public "$vpcId"
    ./service/associate_subnet_to_rt.sh private "$vpcId"

    echo "SUBNETS ASSOCIATED TO ROUTE TABLES"

    #create and attach internet gateway for public subnet
    ./service/create_internet_gateway.sh my-igw-stemilia
    ./service/attach_igw_to_vpc.sh "$vpcId"

    echo "IGW CREATED AND ATTACHED"

    #create public and private EC2 instances
    ./service/runEC2.sh private "$vpcId"
    ./service/runEC2.sh public "$vpcId"

    echo "INSTANCES CREATED"

    
}

main