#!/usr/bin/env zsh

# We don't have all the env vars, let's source zlogin
if [ "$FILCAB_SHELL_INIT" -ne "1" ]; then
  . ~/.zlogin
fi
