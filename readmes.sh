#!/usr/local/bin/bash

limit=3
width=95
cmd="
  bat
    --style=header,grid,numbers
    --terminal-width $(($(($(tput cols) / 100)) * $width))
"

getFiles () {
  list=$(tree -f -i -I "node_modules|.git*|.DS_Store" -a -L $limit)
  count=$(echo "$list" | rga -e README --count)
  paths=$(echo "$list" | rga -e README)
  [[ "$count" -gt 0 ]] && echo "$paths"
}

cmdFiles () {
  files=$(getFiles | tr '\n' ' ')
  [[ ! -z "$@" ]] && cmd="$@"
  [[ ! -z "$files" ]] && $cmd $files
}

cmdFiles "$@" && clear
