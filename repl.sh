#!/usr/local/bin/bash

repl () { 
  temp=$(mktemp --suffix .sh)
  printf "#!/usr/local/bin/bash\n" > $temp
  micro --autosave 1 "$temp:2"
  chmod +x $temp
  . $temp
  rm $temp
}
