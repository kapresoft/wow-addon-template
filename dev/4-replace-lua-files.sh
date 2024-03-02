#!/usr/bin/env zsh

newProjName="AddonSuite"
echo "Renaming occurrences of AddonTemplate to $newProjName":

find . -type f -name '*.lua' -exec grep 'AddonTemplate' {} +
echo "-----"
# mac os
#find . -type f \( -name '*.toc' -o -name '*.xml' \) -exec sed -i '' "s/AddonTemplate/$newProjName/g" {} \;
cmd="find . -type f -name '*.lua' -exec sed -i '' \"s/AddonTemplate/$newProjName/g\" {} \;"
# all others
#cmd="find . -type f -name '*.lua' -exec sed -i \"s/AddonTemplate/$newProjName/g\" {} \;"

echo "Executing: ${cmd}"
eval "${cmd}"


