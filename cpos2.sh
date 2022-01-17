cpos () {
  echo -ne "\x1b[6n" ; read -sd "R" CURPOS
  # \x1b[6n: report cursor position
  # -s: dont echo input from terminal (stdin?)
  # -d: use "R" as the delim
  
  CURPOS=${CURPOS#*[}
  # ^ IDK WHY THIS WORKS BUT IT DOES.
  # https://stackoverflow.com/a/6003016
  # https://www.unix.com/302555492-post2.html

  Y=$(echo "${CURPOS}" | cut -d ';' -f 1)
  X=$(echo "${CURPOS}" | cut -d ';' -f 2)
}

start="5tart position |"

ns
tput cup 12 20
cpos
Y1=$((${Y} - 1))
X1=$((${X} - 1))
echo "${start}"

tput cup $(( $(tput lines) - 6 ))
# one line shorter than the string to print

echo -e "cursor pos:\n+ Y: ${Y}\n+ X: ${X}\n+ Y1: ${Y1}\n+ X1: ${X1}"
tput cup ${Y1} $(( ${#start} + ${X} ))
echo "end position"

tput cup ${Y1} ${X1}
echo -e "\x1b[1m\$T@rT\x1b[0m"

tput cup 0 0
 
