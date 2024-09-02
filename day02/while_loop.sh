#!/bin/bash

# While loops


num=0

#while [[ $num -le 5 ]]
#do 
#	echo "hello"
#        num=$num+1	
#done





# Loop while the number is less than or equal to a certain limit
while [[ $num -le 20 ]]
do
    # Check if the number is even
    if [[ $((num % 2)) -eq 0 ]]
    then
        echo $num
    fi
    # Increment the number by 1
    num=$((num + 1))
done

