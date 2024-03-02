#!/bin/zsh

find . -type f -name "AddonTemplate*" -print0 | while IFS= read -r -d $'\0' file; do
    # Extract the part of the filename after 'AddonTemplate-'
    suffix="${file#*AddonTemplate}"
    # Construct the directory path and new filename
    dir=$(dirname "$file")
    newname="${dir}/AddonSuite${suffix}"

    # Check if the new name differs from the original name
    if [ "$file" != "$newname" ]; then
        echo "Renaming '$file' to '$newname'"
        # example rename, uncomment below
        # mv "$file" "$newname"
    else
        echo "No change needed for: $file"
    fi
done
