#!/bin/bash

SHELL_RESOURCES=~/.shells

# Functions lazily found at
# https://superuser.com/questions/39751/add-directory-to-path-if-its-not-already-there
# directories are only added if they're not there.
# *not exactly* the same semantics as zsh version (which prepends/appends, removing duplicates)
function path-append-dirs() {
  for ARG in "$@"
  do
    set -x
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
      PATH="${PATH:+"$PATH:"}$ARG"
    fi
    set +x
  done
}

function path-prepend-dirs() {
  for ((i=$#; i>0; i--))
  do
    ARG=${!i}
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
        PATH="$ARG${PATH:+":$PATH"}"
    fi
  done
}

for rc in ~/.rc.*; do
  source "$rc"
done

# fix spelling errors for cd, only in interactive shell
shopt -s cdspell

# Make sure we check the window size before every command
shopt -s checkwinsize

# Special-case this script, for now, as it works on both
source ~/.zsh.d/lib/git-prompt.zsh

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

### FIXME: Maybe move these to a common place
for i in ~/.zsh.d/functions/[a-z]*; do
  . $i
done

