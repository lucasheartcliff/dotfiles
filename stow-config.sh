#!/bin/bash

rm -f $HOME/.zshrc
mv $HOME/.config/ $HOME/.config_old

# Define an array of folders to ignore
declare -a ignored_folders=("assets" "tools"  "utils"  "font-unicode")

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
cp -r $HOME/.config_old/* $HOME/.config/
