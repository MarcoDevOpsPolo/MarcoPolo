#!/bin/bash

# Check if SSH agent is already running
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    eval "$(ssh-agent)"
fi

ssh-add ~/Documents/CODECOOL/practices/DevOps/AWS/emi_rsa.pem

#use ProxyJump -J 
ssh -J ec2-user@63.176.179.233 ec2-user@10.0.1.32