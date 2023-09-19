#!/bin/bash

# Define an array of folders to ignore
declare -a ignored_folders=("assets" "tools" "font-unicode")

# Loop through all subdirectories and stow them
for package in */; do
  package_name="${package%/}"
  
  # Check if the package should be ignored
  if [[ " ${ignored_folders[@]} " =~ " $package_name " ]]; then
    echo "Ignoring package: $package_name"
  else
    stow -D "$package_name"
    stow "$package_name"
  fi
done