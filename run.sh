#!/bin/bash

#stop if any of the scripts fails
set -e 

# Default values
VPC_NAME="my-vpc"
SUBNET_NAME="my-subnet"
INSTANCE_NAME="my-instance"
RT_NAME="my-rt"
IGW_NAME="my-igw"
NATGTW_NAME="my-nat-gtw"
RSA_KEY_NAME="id_rsa.pem"
RSA_KEY_PATH="$HOME/ssh/"


# Computed values
PRIVATE_SUBNET="private-$SUBNET_NAME"
PUBLIC_SUBNET="public-$SUBNET_NAME"
PUBLIC_INSTANCE="public-$INSTANCE_NAME"
PRIVATE_INSTANCE="private-$INSTANCE_NAME"
PRIVATE_RT="private-$RT_NAME"
PUBLIC_RT="public-$RT_NAME"
SSH="${RSA_KEY_PATH}${RSA_KEY_NAME}"

# Function to show usage/help message
usage() {
    echo "Usage: $0 [--vpc-name <name>] [--subnet-name <name>] [--instance-name <name>] [--rt-name <name>] [--igw-name <name>] [--natgtw-name <name>] [--rsa-key-name <name>] [--rsa-key-path </your/path/>]"
    exit 1
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --vpc-name)
            VPC_NAME="$2"
            shift 2
            ;;
        --subnet-name)
            SUBNET_NAME="$2"
            shift 2
            ;;
        --instance-name)
            INSTANCE_NAME="$2"
            shift 2
            ;;
        --rt-name)
            RT_NAME="$2"
            shift 2
            ;;
        --igw-name)
            IGW_NAME="$2"
            shift 2
            ;;
        --natgtw-name)
            NATGTW_NAME="$2"
            shift 2
            ;;
        --rsa-key-name)
            RSA_KEY_NAME="$2"
            shift 2
            ;;
        --rsa-key-path)
            RSA_KEY_PATH="$2"
            shift 2
            ;;
        --help)
            usage
            ;;
        *)
            echo "Unknown parameter: $1"
            usage
            ;;
    esac
done

# Run the AWS scripts
main() {
    ./service/create_vpc.sh 
    vpcId=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=$VPC_NAME" --query "Vpcs[0].VpcId" --output text)

    echo "VPC CREATED"

    #creating a Vpc will automatically generate a route-table. Let's name it private route table:
    ./service/edit_rt_tag_name.sh "$vpcId" "$PRIVATE_RT"

    echo "PRIVATE ROUTE TABLE RENAMED"

    #create private&public subnet
    ./service/create_subnet.sh "$PRIVATE_SUBNET" 10.0.1.0/24 "$vpcId"
    ./service/create_subnet.sh "$PUBLIC_SUBNET" 10.0.2.0/24 "$vpcId"

    echo "SUBNETS CREATED"

    #create public route table as well
    ./service/create_rt.sh "$vpcId" "$PUBLIC_RT"

    echo "PUBLIC ROUTE TABLE CREATED"

    #associate the subnets to the corresponding route tables
    ./service/associate_subnet_to_rt.sh public "$vpcId" "$RT_NAME" "$SUBNET_NAME"
    ./service/associate_subnet_to_rt.sh private "$vpcId" "$RT_NAME" "$SUBNET_NAME"

    echo "SUBNETS ASSOCIATED TO ROUTE TABLES"

    #create and attach internet gateway for public subnet
    ./service/create_internet_gateway.sh my-igw-stemilia
    ./service/attach_igw_to_vpc.sh "$vpcId"

    echo "IGW CREATED AND ATTACHED"

    #create public and private EC2 instances
    ./service/runEC2.sh private "$vpcId"
    ./service/runEC2.sh public "$vpcId"

    echo "INSTANCES CREATED"

    #create NAT gateway for the private instance
    ./service/create_natgw.sh "$vpcId"

    echo "NAT GATEWAY CREATED"

    #add SSH rule to the security group in order to make SSH possible for the public instance
    ./service/put_sshRule_to_sg.sh "$vpcId"

    echo "SSH ALLOWED"

    #add routes to route tables
    ./service/add_route.sh public "$vpcId"
    ./service/add_route.sh private "$vpcId"

    echo "ROUTES ADDED TO ROUTE TABLES"
}

main

echo "YOUR VPC SYSTEM CREATED SUCCESSFULLY!"

publicIP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=my-public-instance-stemilia" --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
echo "public: $publicIP" 
privateIP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=my-private-instance-stemilia" --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
echo "private: $privateIP"

./service/ssh.sh "$publicIP" "$privateIP"