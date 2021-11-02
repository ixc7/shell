#!/usr/local/bin/bash

source utils.sh

getCoordinates () {
  str=$1 
  read -rsn1 key

  [[ $key != m ]] && 
  [[ $key != M ]] &&
  str+=$key &&
  getCoordinates $str ||

  y=$(( $(echo $str | cut -d ';' -f 2) - 1 ))
  x=$(( $(echo $str | cut -d ';' -f 1) - 1 ))

  [[ $key == M ]] && 
  tput setab 4 ||
  tput setab 12

  tput cup $y $x && printf ' '
}

enableMouse () {
  tput civis
  clear
  printf "\x1b[?1000;1006;1016h"
  header "mouse reporting enabled. press 'q' to quit."

  while true; do
    read -rsn1 key
    case $key in
      'q')
        reset && echo "quit" && exit 0
      ;;
      '[')
        read -rsn3 key
        if [[ $key == "<0;" ]]; then
          read -rsn 3 key
          getCoordinates $key
        fi
      ;;
    esac
  done
}

enableMouse
