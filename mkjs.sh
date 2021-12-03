#!/usr/local/bin/bash

# TODO
# nicer prompts

[[ -z $1 ]] && 
  echo "usage: mkjs <filename>" &&
  exit 0

trap cleanup EXIT SIGINT

file="${PWD}/${1}.js"
exists=0

cleanup () {
  tput cnorm
  exit 0
}

if [[ ! -f $file ]]
then
  (
    touch $file &&
    echo -e "#!/usr/bin/env node" > $file &&
    chmod +x $file
  ) || cleanup
else 
  exists=1
fi

repl () {
  echo -ne "\x1b[?25h\x1b[0m\x1Bc\x1b[3J"
  
  (
    $EDITOR $file &&
    node $file -check >> /dev/null 2>&1  &&
    node $file &&
    getinput
  ) || (
    echo -ne "\x1b[?25l\x1b[1m\x1b[38;5;196m\x1b[1;1H"
    echo -ne "\nsyntax error\n\n"
    # echo -ne "\x1b[2m\x1b[38;5;88m"
    echo -ne "\x1b[38;5;88m"
    node $file
    echo -ne "\x1b[1m\n"
    read -p "[<any key> contine <nqNQ> quit] " line

    if (
      [[ "${line^^}" == "Q" ]] ||
      [[ "${line^^}" == "N" ]]
    )
    then
      rm -f $file
      la && cleanup
    else 
      repl
    fi
  )
}

getinput () {
  [[ $exists -gt 0 ]] &&
    la &&
    echo -e "\nupdated ${file}" &&
    cleanup

  [[ ! -z $(which jsdf) ]] &&
  [[ -f $file ]] &&
  [[ $(jsdf $file) -lt 1 ]] &&
    rm -f $file &&
    la &&
    cleanup
  
  echo
  read -p "save ${file}? [<any key> save <nqNQ> quit <eE> edit] " line

  if [[ "${line^^}" == "E" ]]
  then
    repl
  elif (
    [[ "${line^^}" == "Q" ]] ||
    [[ "${line^^}" == "N" ]]
  )
  then
    rm -f $file
  fi

  la
  cleanup
}

repl
