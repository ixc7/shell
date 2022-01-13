#!/usr/local/bin/bash

trap cleanup EXIT SIGINT SIGTERM SIGKILL

cleanup () {
  stty echo
  tput civis
  tput sgr0
  exit 0
}

get_number () {
  exp='^[+-]?[0-9]+([.][0-9]+)?$'
  read -p 'speed : ' speed
  ! [[ ${speed} =~ ${exp} ]] && 
    get_number ||
    echo -ne $speed
}

default=""
[[ ! -z "$@" ]] &&
  default="$@"

stty -echo
input=$(rlwrap -S 'search : ' -P "${default}" -o cat)
stty echo
echo -e "searching for ${input}"

url=$(ytfzf -L ${input})
[[ -z $url ]] && cleanup

speed=$(get_number)
[[ -z $speed ]] && cleanup

filename="$(echo -e ${url} | cut -d '=' -f 2)"
suffix=".wav"

mpv "${url}" \
  --no-video \
  --speed="${speed}" \
  --audio-pitch-correction=no

read -p 'save file? <yY/*> ' save
# get rid of the stupid key icon
stty -echo

if 
  [[ $save == "Y" ]] || 
  [[ $save == "y" ]]
then
  savedname=$(rlwrap -S 'filename : ' -P "${filename}" -o cat)
  # ...again
  stty echo

  [[ -z "$savedname" ]] && savedname="$filename"
  savedfile="${SLOMO_DIR}${savedname}_$(echo ${speed} | tr -d '.')"
  temp=$(mktemp --suffix="${suffix}")
  
  tput civis
  stty -echo
  stty flusho
  
  youtube-dl \
     -o "${savedfile}.%(ext)s" \
     -x --audio-format wav \
     --audio-quality 0 \
     --format bestaudio ${url} &&
  rubberband \
    --tempo ${speed} \
    --frequency ${speed} \
    "${savedfile}${suffix}" "${temp}" &&
  mv "${temp}" "${savedfile}${suffix}"

  stty -flusho
  stty echo
  tput cnorm
  tput bold
  echo -e "\nfile saved to ${savedfile}${suffix}\n"
  tput sgr0
fi
