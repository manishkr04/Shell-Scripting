#!/bin/bash


# FUnction to add two number

add_number(){
	num1=$1
	num2=$2
	sum=$((num1+num2))
	echo "The sum of $num1 and $num2 is : $sum"
}



# Function to check if a number is even or odd
check_even_odd() {
    local num=$1
    if [[ $((num % 2)) -eq 0 ]]; then
        echo "$num is even."
    else
        echo "$num is odd."
    fi
}



#calling the functions
add_number $1 $2 
check_even_odd 7
