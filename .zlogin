#!/usr/bin/env zsh
# echo sourced zlogin

# When profiling, uncomment this and (optionally) the last line
# zmodload zsh/zprof

if [ -z "${FILCAB_SHELL_INIT}" ]; then
  # Make path and fpath entries unique before we do anything
  typeset -gU path
  typeset -gU fpath

  source ~/.shells/profile
fi

# zprof
