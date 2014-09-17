#!/usr/bin/env zsh

if [[ x`uname -s` == 'xDarwin' ]]; then
  # Have we brewed a new vim?
  if [ -f ~/dev/homebrew/bin/vim -a -x ~/dev/homebrew/bin/vim ]; then
    export EDITOR=~/dev/homebrew/bin/vim
  fi
fi

if [ -z "$EDITOR" ] && hash vim &> /dev/null; then
  export EDITOR=vim
fi

# completion
autoload -U compinit
compinit

# correction
setopt correctall

# prompt

autoload -U promptinit
promptinit
prompt walters

autoload colors
colors
setopt prompt_subst

# If a pattern doesn't glob, use it verbatim in the command
unsetopt nomatch


# Emacs keybindings
bindkey -e

# set zsh function directory and autoload them:
[[ $fpath = */.zsh.d/* ]] || fpath=( ~/.zsh.d/functions $fpath )
autoload ${fpath[1]}/*(:t) 2>/dev/null

# autoload macports' completion functions
MP_COMP_DIR=/opt/local/share/zsh/4.2.7/functions
[[ $fpath = *$MP_COMP_DIR* ]] || fpath=( $fpath $MP_COMP_DIR )

# autoload homebrew stuff
HB_SITE_DIR=~/dev/homebrew/share/zsh/site-functions
[[ $fpath = *$HB_SITE_DIR* ]] || fpath=( $fpath $HB_SITE_DIR )

# For oh-my-zsh
export ZSH=$HOME/.zsh.d/oh-my-zsh
export ZSH_THEME="filcab"
#export ZSH_THEME="mortalscumbag"
# Maybe also add the extract plugin...
plugins=(brew git svn macports osx)
# for now, make our ~/.zsh.d the custom dir for oh-my-zsh
export ZSH_CUSTOM=$HOME/.zsh.d
source $ZSH/oh-my-zsh.sh



# case-insensitive (all),partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# verbose completion
zstyle ':completion:*' verbose yes

source ~/.paths

# Make us smile a bit...
# I should increase the paranoia level on this.
if type fortune &>/dev/null;
then
  echo
  fortune -s
  echo
fi

# Restrict to a directory we control
if type ~/dev/homebrew/bin/vimpager &>/dev/null;
then
  export PAGER="less -R"
  #export PAGER=vimpager
fi

# Load ninja autocomplete
source ~/.zsh.d/functions/_ninja
# Ninja status: [left/running/finished]
export NINJA_STATUS="[%u/%r/%f] "

# Load additional zsh stuff
for f in ~/.zsh.d/rc.*; do
  source $f
done

# Load additional stuff
for f in ~/.rc.*; do
  source $f
done


