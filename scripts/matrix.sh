#!/bin/bash

first_yaml_file=$(find "configs" -maxdepth 1 -type f \( -name '*.yaml' -o -name '*.yml' \) -print -quit)

# Read the YAML file and extract fields in a loop

which yq > /dev/null 2>&1 || sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 > /dev/null 2>&1 && sudo chmod a+x /usr/local/bin/yq > /dev/null 2>&1

if [ -n "$first_yaml_file" ]; then
    types=$(yq eval '. | keys | .[]' "$first_yaml_file")
    
    echo  '{"include": [' > config.json
    for type in $types; do
        keys=$(yq eval ".$type | keys | .[]" "$first_yaml_file")
        for key in $keys; do
            value=$(yq eval ".$type[\"$key\"]" "$first_yaml_file")
            var_name="${key}"
            declare "$var_name=$value"
        done
        template_owner="${template%%/*}"
        owner_uppercase=$(echo "$owner" | tr '[:lower:]' '[:upper:]')
        echo "{\"repopath\":\"$owner/$repo\", \"dir\":\"$dir\", \"repo\":\"$repo\", \"name\":\"$name\", \"owner\":\"$owner\", \"template_owner\":\"$template_owner\", \"OWNER_UPPERCASE\":\"$owner_uppercase\", \"template\":\"$template\"  }">> config.json
        echo "," >> config.json
                
    done
    awk 'NR>1 {print prev} {prev=$0} END {print "]}" }' config.json > temp && mv temp config.json # replace last ,
fi
