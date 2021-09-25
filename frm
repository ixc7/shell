#!/bin/bash

# fzf + rga + micro

frm () {

	RG_PREFIX="rga --files-with-matches"
	EDITOR="micro"	
	local file

	file="$(
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
			fzf --sort --border vertical \
			  --preview=" \
			    [[ ! -z {} ]] && 
			    rga --pretty --sort modified --hidden {q} {} &&
			    echo {} > .file_name &&
 			    rga --line-number --hidden {q} {} | head -n 1 | cut -d: -f1  > .line_number
			  " \
				--disabled -q "$1" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="right:75%:border-sharp:wrap:cycle" \
				--color=16,border:red,fg+:red \
				--prompt='? ' --pointer='>' --marker='+ ' \
				--margin=8,4 --padding=1,2 --cycle -m --layout=reverse-list \
				--bind=left:up,right:down,up:preview-up,down:preview-down \
	)" &&

  FILE=$(cat .file_name)
  LINE=$(cat .line_number)
	rm .file_name .line_number &&
  [[ ! -z $file ]] &&
  [[ ! -z $FILE ]] &&
  [[ ! -z $LINE ]] &&
	$EDITOR $(echo $(pwd)/$FILE:$LINE)

}

frm $1
