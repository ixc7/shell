#!/usr/local/bin/bash

trap cleanup EXIT

char="#"
direction="r"
at_right_margin=false
count=1
Y=0
X=0

cleanup () {
  printf "\x1Bc\x1b[3J\x1b[?25h\x1b[0m"
  # no scrollback + tput cnorm sgr0
}

random256 () {
  echo $(( $RANDOM % 256 + 1 ))
  # https://linuxhint.com/generate-random-number-bash/
}

printf "\x1Bc\x1b[3J\x1b[?25l"
printf "R: ${count}\t\t\n\n"

while true; do
  echo -ne "\x1b[1;1H"
  if [[ $(( ${count} * ${count} )) -ge $(tput cols) ]]; then
    at_right_margin=true
    direction="l"
    stop_count=$(( ${count} - 1 ))
    stop_char_count=$(( ${count} - 2 ))
    char_line=$( for i in $(seq $(( ${stop_char_count} * ${stop_char_count} )) ); do printf "${char}"; done )
    
  elif [[ $(( ${count} * ${count} )) -le $(tput cols) ]]; then
    char_line=$( for i in $(seq $(( ${count} * ${count} )) ); do printf "${char}"; done )
  fi
  
  char_rows=$( for i in $(seq $(( $(tput lines) - 4 )) ); do printf "${char_line}\n"; done )
    
  if [[ $(( ${count} * ${count} )) -ge $(tput cols) ]]; then
    direction="l"
  elif [[ ${count} -le 1 ]]; then
    echo -ne "\x1b[2J\x1b[3J"
    # only have to clear the screen once if moving right.
    direction="r"
  fi

  if [[ "${direction}" == "l" ]]; then
    count=$(( ${count} - 1 ))

    if [[ ${at_right_margin} == true ]]; then
      at_right_margin=false
      count=$(( ${count} - 1 ))
    fi

    # reformat lines/rows with whitespace
    line_space_length=$(( $(tput cols) - ${#char_line} ))
    line_space=$(for i in $(seq  ${line_space_length}); do printf " "; done)
    char_line=$(
      for i in $(seq $(( ${count} * ${count} )) ); do
        printf "${char}"
      done
    )
    char_rows=$( for i in $(seq $(( $(tput lines) - 4 )) ); do printf "${char_line}${line_space}\n"; done )

    printf "L: ${count}    \n\n"

  elif [[ "${direction}" == "r" ]]; then
    printf "R: ${count}    \n\n"
    count=$(( ${count} + 1 ))
  fi

  printf "${char_rows}"
  sleep 0.2
done

