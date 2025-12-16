#!/bin/bash

# simplebackup.sh - create backups of .conf files
# usage: ./simplebackup.sh
# Backups will be named: filename.conf.bak.TIMESTAMP

set -euo pipefail

# Timestamp for backup
dat=$(date +%F_%H-%M-%S)

# Find all .conf files under /etc
find /etc/ -type f -iname "*.conf" | while IFS= read -r file; do
    backup="${file}.bak.${dat}"
    
    # Skip if backup already exists (very unlikely with timestamp)
    if [[ -f "$backup" ]]; then
        echo "Won't copy file $backup"
        continue
    fi

    echo "Backing up $file -> $backup"
    cp "$file" "$backup"
done
