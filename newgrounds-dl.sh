#!/usr/local/bin/bash

# https://www.newgrounds.com/portal/view/310005

ngdl () {
  [[ -z "${1}" ]] && echo "usage: ngdl <newgrounds.com url>" && exit 0
  echo -e "fetching .swf file from ${1}"

  filename=$(
    curl -s "${1}" | 
    rga -e 'uploads.ungrounded.net' | 
    cut -d '{' -f 2 | 
    cut -d ',' -f 1 | 
    cut -d ':' -f 2-3 | 
    tr -d '"' | 
    tr -d '\\'
  )

  temp=$(mktemp --suffix=".swf")
  echo -e "downloading ${filename}"
  
  curl -s "${filename}" -o "${temp}" && echo "opening player" && ruffle "${temp}" ||
  echo "error loading file" && rm -rf "${temp}" && exit 0
}
