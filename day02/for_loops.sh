#!/bin/bash

# This is for loops


# for ((num=1; num<=3; num++))
# do 
# 	mkdir "demo$num"
# done

#for loops using an arguments 

<<task
1 is argument 1 which is folder name
2 is start range 
3 is end rangeask
task

for((num=$2; num<=$3; num++))
do 
	mkdir "$1$num"
done
