#!/bin/bash

read -p "Enter username: " username

echo "You entered $username"

sudo useradd -m $username

echo "New user added"

#check the added user 
cat /etc/passwd | grep $username

sleep 4

sudo userdel -r $username

echo "User has been deleted"
