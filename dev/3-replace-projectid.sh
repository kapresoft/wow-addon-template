#!/usr/bin/env zsh

templateProjID="782096"
# add the new projectID
newProjID="NEWPROJECTID"

echo "Renaming occurrences of ProjectID[$templateProjID] to $newProjID"
fileTypes="-name '*.toc' -o -name '*.xml' -o -name '*.yaml' -o -name '*.yml' -o -name '*.yaml'"
find_cmd="find . -type f \( $fileTypes \) -exec grep '${templateProjID}' {} +"

echo "Executing: ${find_cmd}"
eval "${find_cmd}"

# mac os
#find . -type f \( -name '*.toc' -o -name '*.xml' \) -exec sed -i '' "s/AddonTemplate/$newProjID/g" {} \;
cmd="find . -type f \( $fileTypes \) -exec sed -i '' \"s/$templateProjID/$newProjID/g\" {} \;"
# all others
# cmd="find . -type f \( $fileTypes \) -exec sed -i \"s/$templateProjID/$newProjID/g\" {} \;"

echo "Executing: ${cmd}"
eval "${cmd}"

find_cmd="find . -type f \( $fileTypes \) -exec grep '${newProjID}' {} +"
echo "----"
echo "Check for new occurrences of ProjectID: $newProjID"
echo "Executing: ${find_cmd}"
eval "${find_cmd}"
