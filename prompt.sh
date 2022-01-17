#!/usr/local/bin/bash

bold_text () {
  tput bold
  printf "$1\r"
  tput sgr0
}

up_arrow () {
  printf "\033[1A"
}

down_arrow () {
  printf "\033[1B\r"
}

options=("option 1" "option 2" "option 3" "option 4" "option 5")

init_prompt () {
  echo "select an option"
  prevent_tabs_and_spaces=
  options=("option 1" "option 2" "option 3" "option 4" "option 5")
  len=0
  pos=0
  
  for option in "${options[@]}"
  do
	echo $option
	((len+=1))
  done
  
  for i in "${options[@]}"
  do
    up_arrow
  done

  bold_text "${options[pos]}\r"
  
  while true
  do
    read -r -sn1 t
    case $t in
      "A")
        if [[ pos -gt 0 ]]
        then
          printf "${options[pos]}\r"
          ((pos-=1))
          up_arrow
          bold_text "${options[pos]}\r"
        fi ;; 
      "B")
        if [[ pos -lt len-1 ]]
        then
          printf "${options[pos]}\r"
          ((pos+=1))
          down_arrow
          bold_text "${options[pos]}\r"
        fi ;; 
      "" )
        end_pos=pos
        while [[ end_pos -lt len ]]
        do
          ((end_pos+=1))
          down_arrow
        done
        echo -e "selected ${options[pos]}"
        break ;;
    esac
  done
}

init_prompt
