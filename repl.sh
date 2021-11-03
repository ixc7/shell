#!/usr/local/bin/bash

repl () { 
  temp=$(mktemp --suffix .sh)
  printf "#!/usr/local/bin/bash\n\n\n" > $temp

  micro --autosave 1 --parsecursor true "$temp:3"
  chmod +x $temp && . $temp

  prompt () {
    read -p "filename: " filename
    [[ ! -z "$filename" ]] || prompt
  }

  read -p "enter 'y' to save: " save
  [[ "$save" == "y" ]] &&
    prompt &&
    cp $temp "$(pwd)/$filename"

  rm $temp
}

repl
