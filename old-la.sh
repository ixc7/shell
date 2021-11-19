#!/bin/bash

# ls -A + column formatting

cache=$HOME/.cache/lsa/.amcache
usage="Usage: la [-m <int>] [-d <str>]
       -m <int>: maximum columns
       -d <str>: delimiter character(s)"
len=3
userlen=""
cols=$(tput cols)
delim="┡"

la () {
  while getopts 'd:m:' flag; do
    case "${flag}" in
      d) delim="${OPTARG}" ;;
      m) userlen="${OPTARG}" ;; 
      *) echo "$usage"
         exit 1 ;;
    esac
  done

  # ls -lahFG | tree -C -L 1 | less -R
  clear && printf '\e[3J' && echo
  
  [[ "$userlen" =~ ^[0-9]+$ ]] && len=$userlen
  maxlen="$(( $cols / $len ))"
  [ $cols -lt 100 ] && maxlen="$(( $cols / $len ))"
  [ $cols -lt 65 ] && maxlen="$(( ($cols / $len) * 2 ))"
  
  ls -A1 > $cache
  cat $cache | \
  awk '{printf("%s\n", $0)}' | \
  cut -c 1-$maxlen | \
  awk -v x=$maxlen -v d=$delim \
  '{printf(""d" %-"x"s \n", $0)}' | column
  echo && pwd 
  # && du -hcs -d 1 | grep total
}

la "$@"
