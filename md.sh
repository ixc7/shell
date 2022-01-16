#!/usr/local/bin/bash

[[ -z "${@}" ]] && exit 0

args=false
files=""

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
