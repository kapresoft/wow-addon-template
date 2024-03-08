#!/usr/bin/env zsh

oldProjName="AddonTemplate"
newProjName="AddonSuite"
fileTypes="-name '*.toc' -o -name '*.xml' -o -name '*.yaml' -o -name '*.yml' -o -name '*.yaml'"

echo "Renaming occurrences of $oldProjName to $newProjName"
find_cmd="find . -type d -name '.idea' -prune -o -type f \( $fileTypes \) -exec grep '$oldProjName' {} +"
echo "Executing: $find_cmd"
eval "${find_cmd}"

# mac os
#find . -type f \( -name '*.toc' -o -name '*.xml' \) -exec sed -i '' "s/AddonTemplate/$newProjName/g" {} \;
cmd="find . -type d -name '.idea' -prune -o -type f \( $fileTypes \) -exec sed -i '' \"s/$oldProjName/$newProjName/g\" {} \;"
# all others
# cmd="find . -type d -name '.idea' -type f \( $fileTypes \) -exec sed -i \"s/AddonTemplate/$newProjName/g\" {} \;"

echo "Executing: ${cmd}"
eval "${cmd}"


