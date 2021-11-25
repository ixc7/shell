#!/usr/local/bin/bash

[[ -z $1 ]] && 
  echo "usage: rmw <command>" &&
  exit 1

[[ ! -f $(which $1) ]] &&
  echo -e "${1}: command not found" &&
  exit 1

rm -f $(which $1) && 
  echo -e "removed ${1}" &&
  exit 0
