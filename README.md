# MarcoPolo

## Script Description
Scripts for handling AWS CLI fast and efficiently.
The main goal is to create a basic VPC architecture following the best practices:
The script will provide us: 

- VPC
- Private + Public: 
    - Subnets
    - Instances
    - Route tables
- Internet Gateway
- NAT Gateway

Attached all together and allow SSH connection. 
If everything works properly, by the end of the script you'll ssh into the private instance. 

## Prerequisites
- AWS CLI installed and configured on your computer
- Linux OS (It is a Bash script) 
    - OR any bash script compatible runtime environment

## How to RUN the Script:

### Default parameters
The script has it's own default environmental variables:

```bash
# Default values
VPC_NAME="my-vpc"
SUBNET_NAME="my-subnet"
INSTANCE_NAME="my-instance"
RT_NAME="my-rt"
IGW_NAME="my-igw"
NATGTW_NAME="my-nat-gtw"
RSA_KEY_NAME="id_rsa"
RSA_KEY_PATH="$HOME/ssh/"
AMI_ID="ami-0b5673b5f6e8f7fa7" #region: frankfurt eu-central-1
```

The program will create some computed variables using the aboves for creating and access private/public resources. 
You can determine the values using `--` flags. 
For explore all the options please run: 
```bash
./run.sh --help
```

### Recommended usage:

```bash
./run.sh --rsa-key-name <key-name> \
--rsa-key-path </your/path/to/your/public/key/
```

Make sure that rsa-key-path ends with **`/`**!
Don't use any file specifications (`.pem`, `.pub`, etc) to your key-name! The program will automatically configure it using the **`.pem`** ending!
Make sure that the given path is the exact same path where you saved your public aws rsa key!