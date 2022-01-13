#!/bin/bash

query="$1"
cols=$(tput cols)
lg=$(( ($cols / 5) * 4 ))
sm=$(( $lg / 2 ))
hr1=$(printf "%0.sॠ" $(seq 1 $sm ))
hr2=$(printf "%0.s₪" $(seq 1 $sm ))

echo -e "\x1b[?25h\x1b[0m\x1Bc\x1b[3J\n\nsearching for '$query'\n\n"

pkgs () {
  echo -e "\x1b[38;5;167m${hr1}\x1b[0m\n\x1b[48;5;52m\x1b[38;5;15m'$1 $2'\x1b[0m\n\x1b[38;5;174m${hr1}\n\n\x1b[0m"
  search="$($1 $2)$(echo -e "\n")"
  res=$(echo -e "$search" | rga "$query" -w -i --color always --colors 'match:bg:53' --colors 'match:fg:15'  | fold -w $cols -s)
  echo -e "\x1b[38;5;175m${hr2}\x1b[0m\n\n${res}\n\n\x1b[38;5;139m${hr2}\x1b[0m\n\n"
  
}


pkgs 'brew' "search $query"
pkgs 'port' "search $query"
pkgs 'npm' "search --no-description $query"
pkgs 'cargo' "search $query --limit 100"
pkgs 'ls -a /usr/bin'

