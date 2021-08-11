#!/bin/bash


my_function(){
	local arg1
	local arg2
	arg1=$1
	arg2=$2

	echo "$arg1"
	echo "$arg2"
}


my_function foo "bar te"
