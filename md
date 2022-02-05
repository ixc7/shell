#!/usr/local/bin/bash

trap cleanup EXIT

temp=$(mktemp)
nonPaths=false
defaultList=$(ls | rga -e "readme")
lang="pdf"
list=""
style="base16/flat"
# style="base16/macintosh"

cleanup () {
  rm -f "${temp}" 
  exit 0
}

pager () {
  # "${@}" | highlight -s "${style}" -S "${lang}" -O xterm256 | less -ginr
  "${@}" | highlight -s "${style}" -S "${lang}" -O xterm256 | less -r
  # "${@}" | highlight -s "${style}" -S "man" -O xterm256 | less -r
}

formatText () {
  echo -e "
    \n\r$(figlet -f miniwi "${1}")
    \n\r$(for i in $(seq "$(tput cols)"); do  echo -ne -; done)
    \n\r$(cat "${1}")
  " > "${temp}"
}

setLang () {
  lang=$(basename "${1}" | tr "." "\n" | tail -n 1)
}

render () {
  echo -ne "\x1Bc\x1b[3J" &&
  setLang "${1}" &&
  formatText "${1}" &&
  pager cat "${temp}"
}

# if no args, format/display ${defaultList}, exit
if [[ -z ${*} ]]; then
  if [[ ${#defaultList} -gt 0 ]]; then
    for file in ${defaultList}; do
      [[ -f "${file}" ]] && render "${file}"
    done

    la
  fi
  exit 0
fi

# else, determine kind of args
for arg in "${@}"; do
  # if not a path, stop checking
  if [[ ! -f "${arg}" ]] && [[ ! -d "${arg}" ]]; then
    nonPaths=true
    lang="pdf"
    break
  fi
  # else, add to list
  [[ -f "${arg}" ]] && list="${list} ${arg}"
  [[ -d "${arg}" ]] && list="${list} ${arg}/*"
done

# if non paths, pass args directly
if [[ ${nonPaths} == true ]]; then
  pager "${@}"
# else, format and display files
elif [[ ${#list} -gt 0 ]]; then
  for file in ${list}; do
    isText=$(file --mime-type -b "${file}" | rga -e "text")
    [[ -n "${isText}" ]] && [[ -f "${file}" ]] && render "${file}" 
  done
  la
fi
