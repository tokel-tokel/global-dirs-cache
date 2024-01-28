#!/bin/zsh

0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

if [[ $PMSPEC != *f* ]]; then
  fpath+=( "${0:h}/functions" )
fi

typeset -g GDC_MAX_DIRS=500
typeset -g GDC_SHORT_DIRS=10

typeset -g GDC_BASE_DIR="${0:h}"

typeset -g GDC_WORK_DIR=${GDC_WORK_DIR:-${XDG_CACHE_HOME:-~/.cache}/global-dirs-cache}
: ${GDC_WORK_DIR:=$GDC_BASE_DIR}
GDC_WORK_DIR=${~GDC_WORK_DIR}

# Create working directory if it doesn't exist.
[[ -w $GDC_WORK_DIR ]] || command mkdir -p "$GDC_WORK_DIR" || {
  print -u2 "global-dirs-cache: cannot create working directory $GDC_WORK_DIR"
  return 1
}

function check_dir() {
  dirlist=($(cat ${GDC_WORK_DIR}/dir_list 2> /dev/null))
  typeset -i len=${#dirlist[@]}
  typeset -i i=1
  while [[ $i -le $len ]]
  do
    if [[ ${dirlist[$i]} == $PWD ]]
    then
      unset "dirlist[$i]"
    fi
    let i++
  done
  dirlist+=( $PWD )
  len=${#dirlist[@]}
  if [[ $len -gt $GDC_MAX_DIRS ]]
  then
    dirlist=(${dirlist[@]:$(( GDC_MAX_DIRS - len ))})
  fi
  touch ${GDC_WORK_DIR}/dir_list
  echo ${dirlist[@]} > ${GDC_WORK_DIR}/dir_list
}

add-zsh-hook precmd check_dir
