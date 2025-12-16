#!/bin/bash

set -eo pipefail

# "Include" functions in the script, if present
ADVTOOLS="${HOME}/Downloads/samples/bashing/advtools.sh"
if [[ -r "$ADVTOOLS" ]]; then
  # shellcheck source=/dev/null
  source "$ADVTOOLS"
fi   # <-- This was missing

# Equipment array (if you’ll reuse it later)
declare -a equipment=()

# Prompt for name
read -r -p "What is your name, adventurer? " adventurer
echo "Nice to meet you, $adventurer"

# Ask to play
read -r -p "Would you like to play a game? [y/n] " decision
case "$decision" in
  [Yy] )
    echo "Great! Let's go!"
    # continue into game logic here...
    ;;
  [Nn] )
    echo "Sad to see you go, $adventurer!"
    exit 0
    ;;
  * )
    echo "Please answer 'y' or 'n'."
    exit 1
    ;;
esac