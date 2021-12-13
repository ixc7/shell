#!/usr/local/bin/bash

if
  [[ -z "${1}" ]] ||
  [[ ! -f "${1}" ]] &&
  [[ ! -d "${1}" ]]
then
  echo -e "get - copy path to clipboard\nusage: get <file|dir>" &&
  exit 0 
fi

echo -ne "$(pwd)/${1}" | pbcopy
