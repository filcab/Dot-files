#!/bin/bash

if [ -z "$BASH_VERSION" ]; then
  # echo "This is not bash!"
  return 0
fi


for f in "$SHELL_RESOURCES"/lib/*.bash; do
  source "$f"
done
source "$SHELL_RESOURCES"/lib/git-prompt.sh

if [ -d ~/dev/brew/etc/bash_completion.d ]; then
  for f in ~/dev/brew/etc/bash_completion.d; do
    source "$f"
  done
fi

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
