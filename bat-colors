#!/usr/local/bin/bash

preview () {
  bat --list-themes | \
  fzf \
    --preview-window="right,85%" \
    --preview="bat --theme={} --color=always ${1}" \
    --cycle
}

bat-colors () {
  selected=$(preview ${1})
  msg="--theme=\"${selected}\""
  profile=$(bat --config-file)

  [[ ! -z ${selected} ]] &&
    gsed -i "/--theme=/d" ${profile} &&
    echo ${msg} >> ${profile} &&
    bat ${1}
}

[[ ! -z ${1} ]] &&
[[ -f ${1} ]] &&
  bat-colors ${1} || 
  echo "usage: bat-colors <filename>"
