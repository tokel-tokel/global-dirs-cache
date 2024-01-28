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
  touch ${GDC_WORK_DIR}/dir_list
  dirlist=("${(@f)$(cat ${GDC_WORK_DIR}/dir_list)}")
  typeset -i len=${#dirlist[@]}
  typeset -i newlen=$len
  typeset -i i=1
  while [[ $i -le $len ]]
  do
    if [[ "${dirlist[$i]}" == "$PWD" ]] || [[ -z "${dirlist[$i]}" ]] 
    then
      unset "dirlist[$i]"
      let newlen--
    fi
    let i++
  done
  dirlist+=( "$PWD" )
  let len++
  let newlen++
  i=1
  while [[ $newlen -gt $GDC_MAX_DIRS ]] && [[ $i -le $len ]]
  do
    if [[ -n "${dirlist[$i]}" ]]
    then
      unset "dirlist[$i]"
      let newlen--
    fi  
    let i++
  done
  echo -n > ${GDC_WORK_DIR}/dir_list
  while [[ $i -le $len ]]
  do
    if [[ -n "${dirlist[$i]}" ]]
    then
      echo "${dirlist[$i]}" >> ${GDC_WORK_DIR}/dir_list
    fi
    let i++
  done
}

add-zsh-hook preexec check_dir
