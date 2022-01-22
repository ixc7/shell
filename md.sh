#!/usr/local/bin/bash

default="readme"
nonPaths=false
list=""

parser () {
  ${@} | highlight -s base16/macintosh -S pdf -O xterm256 | less -r
}

# if no args, cat readmes* | highlight
if [[ -z ${@} ]]; then
  if [[ $(ls | rga -e "${default}" | wc -l) -gt 0 ]]; then
    parser cat $(ls | rga -e "${default}" | tr '\n' ' ')
  fi
  exit 0
fi

# else, determine if args are all paths
for arg in ${@}; do
  # if not a path to something, stop checking
  if [[ ! -f ${arg} ]] && [[ ! -d ${arg} ]]; then
    nonPaths=true
    break
  fi
  # if file or dir, add to list
  [[ -f ${arg} ]] && list="${list} ${arg}"
  [[ -d ${arg} ]] && list="${list} ${arg}/*"
done

# if mixed args
if [[ ${nonPaths} == true ]]; then
  parser ${@}
# else, if paths only
elif [[ ${#list} -gt 0 ]]; then
  for file in ${list}; do
    parser cat ${file}
  done
fi
