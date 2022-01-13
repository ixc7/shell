#!/bin/bash

rate=2
esc=$(printf "\x1b")
cup=$(printf "${esc}[${rate}")

while true; do
  read -rsn1 key

  if [[ $key == $esc ]]; then
    read -rsn2 key
  fi

  case $key in
    '[A')
      printf "${cup}A"
      # up
    ;;
    '[B')
      printf "${cup}B"
      # down
    ;;
    '[C')
      printf "${cup}C"
      # right
    ;;
    '[D')
      printf "${cup}D"
      # left
    ;;
    'q')
      reset && exit 0
    ;;
    *)
      printf "${esc}[2K"
    ;;
  esac
done
