#!/bin/bash

read -r conf value < $CONF

IFS=":"

while read -r keyword value
do
	keyword=$(echo "$keyword" | sed 's/"//g')
	value=$(echo "$value" | sed 's/[",]//g')
	if [[ "$keyword" == "city" ]]
	then
		echo "The City is: $value"
	else 
		echo "Keyword $keyword"
		echo "Value is $value"
	fi
done < $1
