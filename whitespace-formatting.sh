#!/usr/local/bin/bash

# TODO: getopts
#       -N ) don't preserve extra newlines

# TODO: detect if input is file
#       - cat if file, echo if string

[[ "${#@}" -gt 0 ]] && 
  msg="${@}" ||
  msg="
       
        here are your options:
          1. enter 'y' to die and go to hell,
          2. any other key to stay alive for a while.
        
        additionally, you can:


          order a meal
            + mcdonalds
            + burger king

          run around
            + aimlessly
              -> in a circle
              -> in a rectangle
            
      please indicate your selection below:
 
  "

getIndent () {
  while IFS= read -r line
  do
    noSpaces=$(echo "$line" | sed 's/ //g')
    if
      [[ ${#noSpaces} -gt 0 ]] &&
      [[ -z "$indent" ]]
    then
      indent=$(echo "$line" | awk -F'[^ ]' '{print length($1)}') &&
      break
    fi
  done < <(echo "$msg")
}

printLine () {
  while IFS= read -r line
  do
    noSpaces=$(echo "$line" | sed 's/ //g')
    [[ ${#noSpaces} -gt 0 ]] &&
      echo "$line" | cut -c "$(($indent + 1))"-"${#line}" ||
      printf "\n"
  done < <(echo "$msg")
  printf "\n"
}

runTests () {
  tput bold &&
  echo "original:" &&
  tput sgr0 &&
  echo "$msg" &&
  getIndent && 
  tput bold &&
  echo "formatted:" &&
  tput sgr0 &&
  printLine
}

runTests
