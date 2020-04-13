#!/bin/bash

if [ -z "$BASH_VERSION" ]; then
  # echo "This is not bash!"
  return 0
fi


# Special-case this zsh script, for now, as it works on both
source "$SHELL_RESOURCES"/zsh/lib/git-prompt.zsh

# fix spelling errors for cd, only in interactive shell
shopt -s cdspell

# Make sure we check the window size before every command
shopt -s checkwinsize

# Combine multiline commands into one in historty
shopt -s cmdhist
# Ignore duplicates, ls without options and builtin commands, as well as lines starting with space
HISTCONTROL=ignorespace:ignoredups
export HISTIGNORE="&:ls:[bf]g:exit"

# Set a history file size
export HISTSIZE=100000
export HISTFILESIZE=$HISTSIZE
shopt -s histappend

### Poor person's history sync on bash (to be called in PROMPT_COMMAND function
# From https://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
_bash_history_sync() {
  builtin history -a
  HISTFILESIZE=$HISTSIZE
  builtin history -c
  builtin history -r
}
