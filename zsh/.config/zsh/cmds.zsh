#!/bin/sh

# cd ls
# enter dir and immediately show contents
cdls () {
  cd $*
  ls
  #echo '' # open line for clarity
}

# extract archive
extract () {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2)   tar xvjf $1    ;;
      *.tar.gz)    tar xvzf $1    ;;
      *.tar.xz)    tar xvJf $1    ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xvf $1     ;;
      *.tbz2)      tar xvjf $1    ;;
      *.tgz)       tar xvzf $1    ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *.xz)        unxz $1        ;;
      *.exe)       cabextract $1  ;;
      *.ace)       unace $1       ;;
      *.arj)       unarj $1       ;;
      *)           echo "'$1': unrecognized file compression" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# mkcd
# create a directory structure and jump to the bottom one
mkcd () {
  mkdir -p "$1" && cd "$1"
}


# fancy-ctrl-z () {
#   if [[ $#BUFFER -eq 0 ]]; then
#     BUFFER="fg"
#     zle accept-line
#   else
#     zle push-input
#     zle-clear-screen
#   fi
# }
#
# zle -N fancy-ctrl-z
# bindkey '^Z' fancy-ctrl-z
#
# custom-ls () {
#   if [[ $IS_MAC_OS == 1 ]]; then
#     flags="-G"
#   else
#     flags="--color --group-directories-first"
#   fi
#   if [[ "$@" =~ "-l" ]]; then
#     ls ${=flags} $@ | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(" %o ",k);print}'
#   else
#     command ls ${=flags} $@
#   fi
# }


nuke () {
   ps ax | ag $@ | ag -v ag | cut -d' ' -f 1 | xargs kill -9
}
