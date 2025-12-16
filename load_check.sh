#!/bin/bash

LOGFILE="/tmp/load_check.log"
touch "$LOGFILE"

# Number of CPU cores
CORES=$(sysctl -n hw.ncpu)

# Set TEST_MODE=1 for testing, 0 for normal operation
TEST_MODE=1

# Threshold
if [ "$TEST_MODE" -eq 1 ]; then
    THRESHOLD=1          # low threshold for testing
else
    THRESHOLD=$CORES     # real threshold = number of cores
fi


# w output: load averages at end of first line
loads=$(w | head -1 | awk -F'load averages?: ' '{print $2}' | tr ',' ' ')

# Current timestamp
timestamp=$(date '+%Y-%m-%d %H:%M:%S')


for load in $loads; do
    # Use awk for decimal comparison
    awk -v l="$load" -v t="$timestamp" -v f="$LOGFILE" -v th="$THRESHOLD" \
    'BEGIN { 
        if (l >= th) { 
            msg = t ": WARNING! Load average " l " exceeds threshold " th
            print msg       # print to terminal
            print msg >> f  # append to log file
        } 
    }'
done

echo "Check complete. Results saved to $LOGFILE"