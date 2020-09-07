#!/bin/bash
set -e

if [[ -z "$INPUT_ASSET_NAME" ]]; then
  echo "Missing file input in the action"
  exit 1
fi

if [[ -z "$INPUT_GITHUB_TOKEN" ]]; then
  echo "Missing GITHUB TOKEN in the action"
  exit 1
fi


if [[ -z "$GITHUB_REPOSITORY" ]]; then
  echo "Missing GITHUB_REPOSITORY env variable"
  exit 1
fi

OWNER_REPOSITORY=$GITHUB_REPOSITORY
if ! [[ -z ${INPUT_REPOSITORY} ]]; then
  OWNER_REPOSITORY=$INPUT_REPOSITORY;
fi

list_asset_url="https://api.github.com/repos/${OWNER_REPOSITORY}/releases/${INPUT_RELEASE}?access_token=${INPUT_GITHUB_TOKEN}"
echo "url" +$list_asset_url

# get url for artifact with name==$artifact
asset_url=$(curl "${list_asset_url}" | jq ".assets[] | select(.name==\"${INPUT_ASSET_NAME}\") | .url" | sed 's/\"//g')
echo "url" + $asset_url
# download the artifact
curl -vLJO -H 'Accept: application/octet-stream' \
    "${asset_url}?access_token=${INPUT_GITHUB_TOKEN}"


echo "::set-output name=result::success"