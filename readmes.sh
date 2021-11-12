#!/usr/local/bin/bash

limit=4
percent=100
width=$(($(($(tput cols) * $percent)) / 100))
divider=$(printf '%0.s=' $(seq 1 $width))

dname () {
  [[ ! -z "$1" ]] &&
    dirname $i | \
    rev | \
    cut -d '/' -f 1 | \
    rev
}

preview-all () {
  [[ ! -z "$@" ]] &&
    for i in "$@"
    do
      temp=$(mktemp --suffix=.md)
      echo -e "\n\n$divider\n\n$(figlet -w $width $(dname $i))\n\n$divider\n\n$(cat $i)\n" > $temp
      allfiles="${allfiles} $temp"
    done
    bat --plain -f $allfiles
    rm -f $allfiles
}

preview-one () {
  [[ ! -z "$@" ]] &&
    for i in "$@"
    do
      echo -e \
      "\n$(figlet -w $(tput cols) $(dname $i))\n\n$divider\n\n$(cat $i)" | \
      bat \
        --style=grid \
        --terminal-width $width \
        --language=markdown
    done
}

getFiles () {
  list=$(find . -mindepth 1 -maxdepth $limit ! -type l)
  count=$(echo "$list" | rga -e README --count)
  paths=$(echo "$list" | rga -e README)

  [[ "$count" -gt 0 ]] &&
    echo "$paths"
}

init () {
  files=$(getFiles | tr '\n' ' ')

  [[ ! -z "$files" ]] &&
    preview-one $files
}

[[ ! -z $1 ]] &&
  limit=$1

init && la
