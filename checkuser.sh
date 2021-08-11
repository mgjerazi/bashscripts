#!/bin/bash

read username

line=$(grep $username /etc/passwd | tr ":" " ")

arr=($line)

echo ${arr[4]}
echo ${arr[5]}
echo ${arr[6]}
