#!/bin/bash

# Current date and time
date

# Number of CPUs
echo "Number of CPUs:"
sysctl -n hw.ncpu

# Total RAM in kB
echo "RAM in kB:"
sysctl -n hw.memsize | awk '{print int($1/1024)}'

# Disk space on root partition
echo "Disk space on root partition (used in KB):"
df -k / | awk 'NR==2 {print $3}'

# Disk space on home partition
echo "Disk space on home partition (used in KB):"
df -k $HOME | awk 'NR==2 {print $3}'

# Number of running processes
echo "Number of processes:"
ps aux | wc -l

# Number of logged in users
echo "Number of logged in users:"
who | wc -l
