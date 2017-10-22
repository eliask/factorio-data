#! /usr/bin/env bash
set -eu

# Prerequisite: build the docker image as follows:
#     docker build -t factorio-data-extractor .

# Ensure dependencies exist:
which docker >/dev/null
which jq >/dev/null
which pup >/dev/null

extract() {
  docker run \
  -i --rm=true \
  factorio-data-extractor \
  bash -c '
  mkdir -p factorio &&
  cd factorio &&
  cat > foo.tar &&
  tar xf foo.tar &&
  node /package/bin/factorio-extractor.js \
  -d /factorio/factorio \
  -o /output.json >&2 &&
  cat /output.json
  ' < "$1"
}

curl -fsL \
  https://www.factorio.com/download-headless/stable \
  https://www.factorio.com/download-headless/experimental \
  | pup -p 'a[href*=linux] attr{href}' \
  | while read -r version_url; do
  version=$(sed 's#.*/\([0-9.]\{3,\}\)/.*#\1#' <<< "$version_url")
  url=https://www.factorio.com/${version_url}

  versions_path=$PWD/versions
  extracted_data=${versions_path}/factorio-data-${version}.json

  if ! [[ -d $versions_path ]]; then
    echo "versions/ does not exist"
    exit 1
  fi

  if [[ -f $extracted_data ]]; then
    echo "File exists already: $version"
  else
    tar_path=$(mktemp)
    curl -fL "$url" > "$tar_path"
    cleanup() { rm -f "$tar_path"; }
    trap cleanup EXIT
    extract "$tar_path" | jq -S . > "$extracted_data"
    cleanup
  fi
done
