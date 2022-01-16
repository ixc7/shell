#!/usr/local/bin/bash

args=false
files=""

if [[ -z ${@} ]]; then
  if [[ $(ls | rga -e readme | wc -l) != 0 ]]; then
    cat $(ls | rga -e readme | tr '\n' ' ') | highlight -s base16/macintosh -S pdf -O xterm256 | less -r
  fi
  exit 0
fi

for arg in ${@}; do
  if [[ ! -f ${arg} ]] && [[ ! -d ${arg} ]]; then
    args=true
  fi

  if [[ -f ${arg} ]]; then
    files="${files} ${arg}"
  fi
done

if [[ ${args} == false ]]; then
  if [[ ${#files} != 0 ]]; then
    cat ${files} | highlight -s base16/macintosh -S pdf -O xterm256 | less -r
  fi
else
  ${@} | highlight -s base16/macintosh -S pdf -O xterm256 | less -r
fi
