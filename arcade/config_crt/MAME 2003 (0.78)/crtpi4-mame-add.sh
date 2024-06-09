#!/bin/bash

# Get the directory where the script is located
directory="$(dirname "$0")"
line='aspect_ratio_index = "23"'

# Find all .cfg files in the directory and its subdirectories, add the line to the beginning of each file
find "$directory" -type f -name "*.cfg" | while read -r file; do
  (echo "$line"; cat "$file") > temp_file && mv temp_file "$file"
done