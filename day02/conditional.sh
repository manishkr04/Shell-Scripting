#!/bin/bash


<< disclaimer
If else statement 
disclaimer

read -p " What is Your age: " age

# -ge > greater than
# -lt > less than
#
if [[ $age -ge 18 && $age -lt 60 ]]; 
then
	echo "You can work"
else
	echo "You are either a minor or a senior "
fi

