#!/usr/local/bin/bash

[[ -z $1 ]] &&
  echo "usage: mkutil <filename>" &&
  exit 1
file=$(basename $1)

bin=/usr/local/bin
[[ -d $bin ]] || mkdir -p $bin

filepath=$bin/$file
newfile=1
[[ -f $filepath ]] ||
newfile=0 &&
(
  touch $filepath &&
  (
    echo -n "#!" && 
    echo $SHELL
  ) >> $filepath
)

editor=nano
[[ ! -z $(echo -n $EDITOR) ]] && editor=$EDITOR

plain="\x1b[0m"
style1="\x1b[38;5;50m\x1b[1m\x1b[7m"
style2="\x1b[38;5;37m\x1b[1m"

$EDITOR $filepath &&
chmod +x $filepath

[[ $newfile -gt 0 ]] &&
  echo -e "updated: ${style1} ${file} ${plain} ${style2}($(which $filepath))${plain}" &&
  exit 0

prompt=$(echo -e "save ${file}? ${style2}[Y/n]${plain} ")
read -p "${prompt}" line
  if [[ ! -z "$line" ]] &&
  (
    [[ "$line" == "Y" ]] ||
    [[ "$line" == "y" ]]
  )
  then
    echo -e "saved ${style1} ${file} ${plain} to ${style2}$(which $filepath)${plain}"
  else
    rm -f $filepath
    echo -e "removed ${file}"
  fi
    
exit 0
