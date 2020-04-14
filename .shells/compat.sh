#!/bin/sh

# Compatibility layer for sh and similar shells
# Other shells might override some functions to be more efficient (e.g: zsh for path_*_dirs)

# Functions lazily found at
# https://superuser.com/questions/39751/add-directory-to-path-if-its-not-already-there
# directories are only added if they're not there.
# *not exactly* the same semantics as zsh version (which always prepend/append, removing duplicates)
path_append_dirs() {
  for ARG in "$@"
  do
    if [ -d "$ARG" ]; then
      case ":$PATH:" in
        *":$ARG:"*)
          # Don't add if it's already there
          ;;
        *)
          PATH="${PATH:+"$PATH:"}$ARG"
          ;;
      esac
    fi
  done
}

path_prepend_dirs() {
  if [ $# -eq 0 ]; then
    echo >&2 error: path_prepend_dirs requires at least one argument
    return 2
  fi

  local acc="$1"
  shift

  for ARG
  do
    acc="${acc}:${ARG}"
    shift
  done

  local IFS=:
  for ARG in $acc
  do
    if [ -d "$ARG" ]; then
      case ":$PATH:" in
        *":$ARG:"*)
          # Don't add if it's already there
          ;;
        *)
          PATH="$ARG${PATH:+":$PATH"}"
          ;;
      esac
    fi
  done
}
