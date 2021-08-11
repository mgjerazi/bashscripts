#!/bin/bash

date
echo "Number of CPUs:"
cat /proc/cpuinfo | grep processor | wc -l

echo "RAM in kB:"
free -k | grep Mem

echo "Disk space on root partition:"
df | grep "/$" | awk {'print $3'}

echo "Disk space on home partition:"
df | grep "home$" | awk {'print $3'}


echo "Number of processes:"
ps aux | wc -l

echo "Number of logged in users:"
w -h | wc -l
