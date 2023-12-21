#!/bin/bash
owner="$OWNER"
repo="$REPO"
template="$TEMPLATE"
GH_PAT="$DEPLOY_TOKEN"

echo $GH_PAT | wc -c

RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "https://api.github.com/repos/$owner/$repo")
if [ "$RESPONSE" -eq 200 ]; then
    echo "$owner/$repo already exists"
else
                
    http_status_code=$(curl -s -o /dev/null -w "%{http_code}" -X POST -H "Accept: application/vnd.github.v3+json" -H "Authorization: Bearer $GH_PAT" -H "X-GitHub-Api-Version: 2022-11-28" "https://api.github.com/repos/$template/generate" -d "{\"owner\":\"$owner\",\"name\":\"$repo\",\"description\":\"$repo\",\"include_all_branches\":true,\"private\":false}")


    # Check the exit status
    if [ "$http_status_code" -ne 201 ]; then
        echo "Failed to create repository. Response: $http_status_code for $template => $owner/$repo"
        curl -X POST -H "Accept: application/vnd.github.v3+json" -H "Authorization: Bearer $GH_PAT" -H "X-GitHub-Api-Version: 2022-11-28" "https://api.github.com/repos/$template/generate" -d "{\"owner\":\"$owner\",\"name\":\"$repo\",\"description\":\"$repo\",\"include_all_branches\":true,\"private\":false}"
        #exit 1
    else
        echo "Repository $owner/$repo created successfully!"
    fi
fi
