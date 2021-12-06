#!/usr/local/bin/bash

LIMIT=3
[[ ! -z $1 ]] && LIMIT=$1

QUERY="readme"
[[ ! -z "$2" ]] && QUERY="$2"

list=$(tree -if -L $LIMIT | rga -e "$QUERY")
count=$(echo -e "$list" | wc -l)

[[ -z "$list" ]] && exit 0

echo -e "
  \rresults for '${QUERY}':
  \rfound: ${count} files
  \rlayers: ${LIMIT}

  \r${list}
" | bat -p -l sh

read -p "copy results to clipboard? (<yY> yes <*> no) " line

if [[ ! -z "$line" ]] &&
(
  [[ "$line" == "Y" ]] ||
  [[ "$line" == "y" ]]
)
then
  echo -e "$list" | pbcopy &&
  echo "list copied to clipboard"
fi
