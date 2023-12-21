first_yaml_file=$(find "configs" -maxdepth 1 -type f \( -name '*.yaml' -o -name '*.yml' \) -print -quit)

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
        RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "https://api.github.com/repos/$ORG_NAME/$repo")
        if [ "$RESPONSE" -eq 200 ]; then
            echo "$ORG_NAME/$repo"
            echo "{\"name\":\"$ORG_NAME/$repo\", \"dir\":\"$dir\", \"repo\":\"$repo\" }">> config.json
            echo "," >> config.json
        fi
    done
    #echo ']}' >> config.json
    awk 'NR>1 {print prev} {prev=$0} END {print "]}" }' config.json > temp && mv temp config.json # replace last ,

fi
