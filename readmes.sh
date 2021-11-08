#!/usr/local/bin/bash

limit=4
width=95

cmd () {
  [[ ! -z "$@" ]] &&
    bat \
      --style=header,grid,numbers \
      --terminal-width $(($(($(tput cols) / 100)) * $width)) \
      "$@"
}

getFiles () {
  list=$(find . -mindepth 1 -maxdepth $limit ! -type l)
  count=$(echo "$list" | rga -e README --count)
  paths=$(echo "$list" | rga -e README)
  [[ "$count" -gt 0 ]] && echo "$paths"
}

init () {
  files=$(getFiles | tr '\n' ' ')
  [[ ! -z "$files" ]] && cmd $files
}

[[ ! -z $1 ]] && limit=$1
init && la
