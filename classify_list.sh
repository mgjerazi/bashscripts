#!/bin/bash

#read -r -p "Enter the name of a file or directory: " path
#Check if it is a file or directory Example: /Users/mariol.gjerazi/Downloads/samples/bashing/classify_and_list.sh

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <file-or-directory> "
    exit 1
fi

path="$1"


if [ -z "$path" ]; then
  echo "No input provided. Exiting."
  exit 1
fi

if [ ! -e "$path" ]; then
  echo "The path '$path' does not exist."
else
  echo "The path '$path' exists."
fi

if [ -f "$path" ]; then
  echo "'$path' is a regular file."
elif [ -d "$path" ]; then
  echo "'$path' is a directory."
else
  echo "'$path' is neither a regular file nor a directory. ${path} may be a special file type (symlink, device, socket, etc.)."
fi

echo
echo "Long listing:"
ls -l "$path"