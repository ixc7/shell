#!/usr/local/bin/bash

quit () {
  [[ -f ${temp} ]] && rm ${temp}
  exit 0
}

trap quit EXIT

list=()
temp=$(mktemp)
nonFiles=false
pager="less -r"
formatter="highlight"
opts=("-s" "base16/flat" "-O" "xterm256")

if [[ -z ${*} ]]; then
  # if no args, format "readme" files
  list=$(ls -a | grep --ignore-case "readme")

  if [[ ${#list} -gt 0 ]]; then
    for file in ${list}; do
      [[ -f "${file}" ]] && 
        ${formatter} "${opts[@]}" "${file}" | ${pager}
    done
  else
    # print help if nothing found
    echo "usage: md [FILES]"
  fi
  exit 0
fi

# parse args
for arg in "${@}"; do
  # break on first non-path
  if [[ ! -f "${arg}" ]] && [[ ! -d "${arg}" ]]; then
    nonFiles=true
    break
  fi

  # add files to list
  [[ -f "${arg}" ]] && list="${list} ${arg}"
  [[ -d "${arg}" ]] && list="${list} ${arg}/*"
done

# pipe input directly to formatter
if [[ ${nonFiles} == true ]]; then
  ${@} | ${formatter} "${opts[@]}" -S "pdf"

# format files from input
elif [[ ${#list} -gt 0 ]]; then
  for file in ${list}; do
    # skip binaries
    count=$(file --mime-encoding -b "${file}" | grep binary | wc -l)

    [[ ${count} -eq 0 ]] &&
      ${formatter} "${opts[@]}" "${file}" | ${pager} || 
      echo "${file} is a binary file"
  done
fi
