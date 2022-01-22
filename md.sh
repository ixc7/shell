#!/usr/local/bin/bash

trap cleanup EXIT

default="readme"
nonPaths=false
list=""
lang="pdf"
temp=$(mktemp)

cleanup () {
  # rm -f ${temp} && echo -e "\x1Bc\x1b[?25h"
  # rm -f ${temp} && echo -ne "\x1b[?25h"
  rm -f ${temp} && la
  exit 0
}

pager () {
  ${@} | highlight -s base16/macintosh -S ${lang} -O xterm256 | less -r
}

format () {
  echo -e "
    \r$(figlet -f miniwi ${1})
    \n\r$(for i in $(seq $(tput cols)); do  echo -ne -; done)
  " > ${temp} &&
  cat ${1} >> ${temp} &&
  echo >> ${temp}
}

setLang () {
  lang=$(basename "${1}" | tr "." "\n" | tail -n 1)
}

render () {
  echo -ne "\x1Bc\x1b[3J\x1b[?25l" &&
  setLang ${1} &&
  format ${1} &&
  pager cat ${temp} 
}

# if no args, format and display ${default}* and exit
if [[ -z ${@} ]]; then
    for file in $(ls | rga -e "${default}"); do
      [[ -f ${file} ]] && render ${file}
    done
  exit 0
fi

# else, determine kind of args
for arg in ${@}; do
  # if not a path, stop checking
  if [[ ! -f ${arg} ]] && [[ ! -d ${arg} ]]; then
    nonPaths=true
    break
  fi
  # else, add to list
  [[ -f ${arg} ]] && list="${list} ${arg}"
  [[ -d ${arg} ]] && list="${list} ${arg}/*"
done

# if non paths, pass args directly
if [[ ${nonPaths} == true ]]; then
  pager ${@}
# else, format and display files
else
  for file in ${list}; do
    [[ -f ${file} ]] && render ${file}
  done
fi
