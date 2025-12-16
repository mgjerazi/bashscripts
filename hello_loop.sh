#!/bin/bash

# Function to print "Hello USER" ./hello_loop.sh 5 Mario
say_hello() {
    local user="$1"
    echo "Hello $user"
}

# First argument: number of times
count="$1"
# Second argument: user name
user="$2"

# Loop from 1 to count
for ((i=1; i<=count; i++)); do
    say_hello "$user"
done
