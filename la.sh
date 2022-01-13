#!/usr/local/bin/bash



##############
#     v1     #
############## 

clear &&
tput setaf 125 &&
(
  (
    [[ ! -z $(which toilet) ]] &&
    toilet -f pagga $(basename $(pwd))
  ) ||
  echo -e $(basename $(pwd))
) &&
tput sgr0 &&
printf "\n" &&
pwd &&
(
  (
    [[ ! -z $(which gls) ]] &&
    gls -lAhSsC --si --color=always
  ) ||
  ls -lAhSsCG
) &&
printf "\n"



##############
#     v2     #
############## 

header=$(basename $(pwd))

(
  clear; tput setaf 125
) &&

(
  (
    [[ ! -z $(which toilet) ]] && 
      toilet -f pagga $header
  ) ||
  echo $header
) &&

(
  tput sgr0; echo; pwd
) &&

(
  (
    [[ ! -z $(which gls) ]] && 
      gls \
        -lAhSsC \
        --si \
        --color=always \
        -I "node_modules" \
        -I ".git" \
        -I ".DS_Store"
  ) || 
  ls -lAhSsCG
) &&

echo
