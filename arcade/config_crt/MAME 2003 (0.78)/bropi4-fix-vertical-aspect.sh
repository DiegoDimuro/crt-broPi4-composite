#!/bin/bash

# Get the directory where the script is located
directory="$(dirname "$0")"

# Array of search and replace pairs
search_replace_pairs=(
  'custom_viewport_width = "364" custom_viewport_width = "395"'
  'custom_viewport_height = "432" custom_viewport_height = "463"'
  'custom_viewport_x = "180" custom_viewport_x = "168"'
  'custom_viewport_y = "30" custom_viewport_y = "10"'
)

# Function to replace lines in a file
replace_lines() {
  local file=$1
  for pair in "${search_replace_pairs[@]}"; do
    local search=$(echo "$pair" | cut -d' ' -f1-3)
    local replace=$(echo "$pair" | cut -d' ' -f4-6)
    # Escape slashes in search and replace strings for sed
    escaped_search=$(echo "$search" | sed 's/[\/&]/\\&/g')
    escaped_replace=$(echo "$replace" | sed 's/[\/&]/\\&/g')
    sed -i '' "s/$escaped_search/$escaped_replace/g" "$file"
  done
}

# Find all .cfg files and process them
find "$directory" -type f -name "*.cfg" | while read -r file; do
  # Replace the lines in each file
  replace_lines "$file"
done