#!/usr/bin/env zsh

# completion
autoload -U compinit
compinit

# correction
setopt correctall

# prompt
autoload -U promptinit
promptinit
prompt walters

# Emacs keybindings
bindkey -e

# set zsh function directory and autoload them:
[[ $fpath = */.zsh.d/* ]] || fpath=( ~/.zsh.d/functions $fpath )
autoload ${fpath[1]}/*(:t) 2>/dev/null

# autoload macports' completion functions
MP_COMP_DIR=/opt/local/share/zsh/4.2.7/functions
[[ $fpath = *$MP_COMP_DIR* ]] || fpath=( $fpath $MP_COMP_DIR )

# For oh-my-zsh
export ZSH=$HOME/.zsh.d/oh-my-zsh
export ZSH_THEME="robbyrussell"
plugins=(git macports osx perl)
source $ZSH/oh-my-zsh.sh

# case-insensitive (all),partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# verbose completion
zstyle ':completion:*' verbose yes

source ~/.paths

# Make us smile a bit...
if type fortune &>/dev/null;
then
  echo
  fortune -s
  echo
fi
