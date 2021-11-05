#!/usr/local/bin/bash

pre=.breaktml.
html=${pre}html
md=${pre}md

[[ -z $1 ]] &&
  echo "usage: breaktml <url>" &&
  exit 1

curl -o $html $1 &&
breakdance $html $md &&
bat \
  --style=header,grid,numbers \
  --terminal-width $(($(($(tput cols) / 100)) * 95)) $md &&
rm $pre* &&
la
