#!/usr/bin/env zsh

# We don't have all the env vars, let's source zlogin
if [ "$FILCAB_SHELL_INIT" != yes ]; then
  source ~/.zlogin
fi
