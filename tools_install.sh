#!/bin/bash

# Directory containing the scripts to be executed
directory="tools/"

# Check if the directory exists
if [ ! -d "$directory" ]; then
	echo "The directory '$directory' does not exist."
	exit 1
fi

# Loop to iterate through all .sh files in the directory
for script in "$directory"*.sh; do
	if [ -f "$script" ] && [ -x "$script" ]; then
		echo "Executing script: $script"
		bash "$script" # Execute the script
	else
		echo "Unable to execute script: $script"
	fi
done

bash font-unicode/init.sh
echo "All scripts have been executed."
