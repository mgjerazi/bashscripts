#!/bin/bash

TARGET_DIR="/private/etc"

read -p "Are you sure you want to delete all .bak.* files in $TARGET_DIR? [y/N] " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Aborting."
    exit 1
fi

# Find and delete all .bak.* files
sudo find "$TARGET_DIR" -type f -name "*.bak.*" | while IFS= read -r file; do
    echo "Processing $file..."
    # Remove immutable flag if set
    sudo chflags nouchg "$file"
    # Clear extended attributes
    sudo xattr -c "$file"
    # Delete the file
    sudo rm -f "$file"
    echo "Deleted: $file"
done

echo "All .bak.* files removed from $TARGET_DIR."
