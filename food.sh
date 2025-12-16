#!/bin/bash

# This script expects 'equipment' array to exist in the main script
# Example:
#   declare -a equipment=()

choice=""

while [[ "$choice" != "q" && "$choice" != "Q" ]]; do

    echo "Pick an equipment:"
    echo "s - spaghetti"
    echo "b - bread"
    echo "q - quit"
    echo

    read -r -p "Your choice: " choice

    case "$choice" in
        [Ss] )
            echo "You picked: Spaghetti"
            equipment+=(spaghetti)
            ;;
        [Bb] )
            echo "You picked: Bread"
            equipment+=(bread)
            ;;
        [Qq] )
            echo "Exiting equipment selection..."
            ;;
        * )
            echo "Not a proper choice"
            ;;
    esac
done