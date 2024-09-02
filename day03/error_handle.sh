#!/bin/bash


create_directory(){
	mkdir demo
}

#calling function
if ! create_directory; 
then
	echo "this code is being exited as the directory already exist"
	exit 1
fi

echo "the directory has be created"
