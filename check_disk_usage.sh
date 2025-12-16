#!/bin/bash

# Log file
LOGFILE="/tmp/disk_usage_check.log"

# Threshold in percent
THRESHOLD=80

# Ensure log file exists
touch "$LOGFILE"

# Get root filesystem usage percentage (numeric)
usage=$(df / | awk 'NR==2 {gsub("%","",$5); print $5}')

# Get current timestamp
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# Log current usage
echo "$timestamp: Root filesystem usage is ${usage}%." >> "$LOGFILE"

# Log a warning if usage exceeds threshold
if [ "$usage" -ge "$THRESHOLD" ]; then
    echo "$timestamp: WARNING! Root filesystem usage exceeds ${THRESHOLD}%!" >> "$LOGFILE"
fi

echo "Check complete. Results saved to $LOGFILE"