#!/bin/bash

# Check if SSH agent is already running
if ! grep -u "$USER" ssh-agent > /dev/null; then
    eval "$(ssh-agent)"
fi

ssh-add ~/Documents/CODECOOL/practices/DevOps/AWS/emi_rsa.pem

#use ProxyJump -J 
ssh -J ec2-user@"$1" ec2-user@"$2"