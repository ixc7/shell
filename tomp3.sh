#!/usr/local/bin/bash

filename=$(echo -e "${@:3}" | tr ' ' '-')

(
  [[ -z "${2}" ]] ||
  [[ -z "${filename}" ]]
) &&
echo "usage: tomp3 <file path> [output name]" &&
exit 0 ||
ffmpeg -i "${1}" "${filename}.mp3"
