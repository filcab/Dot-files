#!/bin/sh

# Compatibility layer for sh and similar shells
# Other shells might override some functions to be more efficient (e.g: zsh for path_*_dirs)

# Functions lazily found at
# https://superuser.com/questions/39751/add-directory-to-path-if-its-not-already-there
# directories are only added if they're not there.
# *not exactly* the same semantics as zsh version (which always prepend/append, removing duplicates)
function path_append_dirs() {
  for ARG in "$@"
  do
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
      PATH="${PATH:+"$PATH:"}$ARG"
    fi
  done
}

function path_prepend_dirs() {
  for ((i=$#; i>0; i--))
  do
    ARG=${!i}
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
      PATH="$ARG${PATH:+":$PATH"}"
    fi
  done
}
