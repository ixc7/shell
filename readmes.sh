#!/usr/local/bin/bash

cmd="bat"
depth=3

getFiles () {
  list=$(tree -f -i -I "node_modules|.git*|.DS_Store" -a -L $depth)
  count=$(echo "$list" | rga -e README --count)
  paths=$(echo "$list" | rga -e README)
  [[ "$count" -gt 0 ]] && echo "$paths"
}

cmdFiles () {
  [[ ! -z "$@" ]] && cmd="$@"
  files=$(getFiles | tr '\n' ' ')
  [[ ! -z "$files" ]] &&
  $cmd $files
}

cmdFiles "$@"
