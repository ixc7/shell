#!/usr/local/bin/bash

inputdir="."

if [[ ! -z "${1}" ]] && [[ -d "${1}" ]]
then
  inputdir="${1}"
elif [[ ! -z "${1}" ]]
then
  echo -e "\n\x1b[1merror: ${1} is not a directory\x1b[0m"
  read -p "use current directory? <y/n>: " res

  if [[ ${res} == "y" ]] ||
  [[ ${res} == "Y" ]] ||
  [[ ${res} == "yes" ]] ||
  [[ ${res} == "Yes" ]]
  then
    echo -e "using \x1b[1m$(pwd)\x1b[0m"
  else
    exit 0
  fi
fi

incount=$(ls -1 ${inputdir} | wc -l)

if [[ ${incount} == 0 ]]
then
  echo -e "\n\x1b[1merror: directory is empty\x1b[0m"
  exit 0
fi

ext=".jpeg"
resultsdir="${inputdir}/converted-to-jpeg"
list="$(ls -1 ${inputdir} | tr ' ' '@')"
precount=0
alreadyexists=0
errorcount=0

if [[ -d "${resultsdir}" ]]
then
  alreadyexists=1
  precount=$(ls -1 ${resultsdir} | wc -l)
else
  mkdir -p "${resultsdir}"
fi

# ns
echo -e "\nscanning for files in \x1b[1m${inputdir}\x1b[0m"

for item in ${list}
do
  prefix=$(echo "${item}" | tr '@' ' ' | cut -d '.' -f 1)
  original=$(echo "${item}" | tr '@' ' ')
  changed="${prefix}${ext}"
    
  if [[ -f "${inputdir}/${original}" ]]
  then
    output="${resultsdir}/${changed}"
    if [[ -f "${output}" ]]
    then
      echo -e "\n\x1b[1mwarning:\x1b[0m can't convert ${original} to ${changed}\n         ${output} already exists"
      trycount=1
      while true
      do
        renamedOutput="${resultsdir}/${prefix}-${trycount}${ext}"
        echo -e "         trying ${prefix}-${trycount}${ext}\x1b[1A"
        if [[ ! -f "${renamedOutput}" ]]
        then
          ffmpeg -n -loglevel fatal -i "${inputdir}/${original}" "${renamedOutput}" &&
          echo -e "         saved as \x1b[1m${prefix}-${trycount}${ext}\x1b[0m" &&
          break
        else
          trycount=$((trycount + 1))
        fi
      done
    else
      ffmpeg -n -loglevel fatal -i "${inputdir}/${original}" "${output}" ||
      echo -e "\n\x1b[1mskipped:\x1b[0m can't convert file: ${original}" && 
        incount=$((incount - 1)) && 
        errorcount=$((errorcount + 1))
        # && rm "${original}"
    fi
  else
    incount=$((incount - 1))
    if [[ -d "${inputdir}/${original}" ]]
    then
      echo -e "\n\x1b[1mskipped:\x1b[0m ${original} is a directory"
    else
      echo -e "\n\x1b[1mskipped:\x1b[0m can not convert file: ${original}"
    fi
  fi
done

if [[ ${incount} == 0 ]]
then
  if [[ ${errorcount} == 0 ]]
  then
    echo -e "\n\x1b[1merror: all files are already in ${ext} format\x1b[0m\n"
  else
    echo -e "\n\x1b[1merror: could not convert any files\x1b[0m\n"
  fi
  if [[ ${alreadyexists} == 0 ]]
  then
    rm -rf "${resultsdir}"
  fi
  exit 0
fi

postcount=$(ls -1 ${resultsdir} | wc -l)
outcount=$(( ${postcount} - ${precount} ))
echo -e "\n\x1b[1mfile conversion complete\x1b[0m\n+ converted \x1b[1m${outcount}\x1b[0m files to ${ext}\n+ results saved to \x1b[1m'${resultsdir}'\x1b[0m\n"
