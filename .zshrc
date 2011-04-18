#!/usr/bin/env zsh

# completion
autoload -U compinit
compinit

# correction
setopt correctall

# prompt
autoload -U promptinit
promptinit
prompt walters

