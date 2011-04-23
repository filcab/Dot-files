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

