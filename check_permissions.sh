#!/bin/bash

LOGFILE="/tmp/etc_permissions_check.log"

# Clear old log
> "$LOGFILE" || {
    echo "Cannot write to $LOGFILE"
    exit 1
}

# Counters
total_files=0
violations=0

# Loop through all regular files in /private/etc
while read -r file; do
    ((total_files++))
    
    # Get file owner and permissions in octal format
    owner=$(stat -f "%Su" "$file" 2>/dev/null)
    perms=$(stat -f "%Lp" "$file" 2>/dev/null)

    [[ -z "$owner" || -z "$perms" ]] && continue

    # Extract "other" write bit
    other_write=$(( (perms % 10) & 2 ))

    # Policy check: owner must be root, other must not be writable
    if [[ "$owner" != "root" || $other_write -ne 0 ]]; then
        echo "File: $file | Owner: $owner | Permissions: $perms" >> "$LOGFILE"
        ((violations++))
    fi
done < <(find /private/etc -type f 2>/dev/null)

# Write summary at the end of the log
{
    echo ""
    echo "Summary:"
    echo "Total files checked: $total_files"
    echo "Violations found: $violations"
} >> "$LOGFILE"

echo "Check complete. Results saved to $LOGFILE"
