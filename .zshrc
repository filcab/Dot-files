#!/usr/bin/env zsh

if [[ x`uname -s` == 'xDarwin' ]]; then
  # Have we brewed a new vim?
  if [ -f ~/dev/brew/bin/vim -a -x ~/dev/brew/bin/vim ]; then
    export EDITOR=~/dev/brew/bin/vim
  fi
fi

if [ -z "$EDITOR" ] && hash vim &> /dev/null; then
  export EDITOR=vim
fi

# gg alias plus v alias to do the previous line with vgg (script in
# ~/.zsh.d/bin), which opens the output of git grep in vim, as a location
# list.
alias gg='git grep'
alias v='eval "v$(fc -l -n -1)"'

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


# Print the exit value if failure.
setopt print_exit_value

# Emacs keybindings
bindkey -e

# set zsh function directory and autoload them:
[[ $fpath = */.zsh.d/* ]] || fpath=( ~/.zsh.d/functions $fpath )
autoload ${fpath[1]}/*(:t) 2>/dev/null

# Always build from source
export HOMEBREW_BUILD_FROM_SOURCE=1
# No analytics
export HOMEBREW_NO_ANALYTICS=1

# For oh-my-zsh
#export ZSH=$HOME/.zsh.d/oh-my-zsh
#export ZSH_THEME="filcab"
##export ZSH_THEME="mortalscumbag"
## Maybe also add the extract plugin...
#plugins=(brew git svn macports osx)
## for now, make our ~/.zsh.d the custom dir for oh-my-zsh
#export ZSH_CUSTOM=$HOME/.zsh.d
#source $ZSH/oh-my-zsh.sh

# C-w should stop deleting at / and other similar boundaries
autoload -U select-word-style
select-word-style bash

# case-insensitive (all),partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# verbose completion
zstyle ':completion:*' verbose yes

source ~/.paths

# Restrict to a directory we control
if type ~/dev/brew/bin/vimpager &>/dev/null;
then
  #export PAGER="less -R"
  export PAGER=vimpager
fi

# Ninja status: [left/running/finished]
export NINJA_STATUS="%e [%u/%r/%f] "

# Disable the creepy, unacceptable, stats requests by CocoaPods
export COCOAPODS_DISABLE_STATS=1

# ls: Use -F with an alias
alias ls="ls -F"

# v From oh-my-zsh
# Save the location of the current completion dump file.
ZSH_COMPDUMP="${ZDOTDIR:-${HOME}}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"

# Load and run compinit
autoload -U compinit
compinit -i -d "${ZSH_COMPDUMP}"

# ^ From oh-my-zsh

for f in ~/.zsh.d/lib/*.zsh; do
  source $f
done

# Load additional zsh stuff
for f in ~/.zsh.d/rc.*; do
  source $f
done

# Load additional stuff
for f in ~/.rc.*; do
  source $f
done


