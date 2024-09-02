#!/bin/bash

# This is single line comment

<< comment
This is 
multiline 
comments
that will
not execute
comment

name="Manish" #this is variable  

echo "Name is $name and date is $(date)"

echo "enter the name:"
read username
echo "Your name is $username"


#understanding the Arguments 
#U have to pass the Arguments while executing the Script

echo "This is 0th Argument: $0 1st Arg $1"
