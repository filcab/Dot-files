#!/usr/bin/env zsh
# echo sourced zlogin

# When profiling, uncomment this and (optionally) the last line
# zmodload zsh/zprof

# Make path and fpath entries unique before we do anything
typeset -gU path
typeset -gU fpath

source ~/.shells/profile

# zprof
