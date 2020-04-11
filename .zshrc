#!/usr/bin/env zsh

SHELL_RESOURCES=~/.shells

# Make path and fpath entries unique
typeset -gU path
typeset -gU fpath

# add our autoloaded zsh-specific functions
__function_dir="$SHELL_RESOURCES/zsh/functions"
fpath=( "$__function_dir" $fpath )
autoload "$__function_dir"/*(:t) 2>/dev/null

# Load general files (used for bash and zsh)
for rc in "$SHELL_RESOURCES"/rc.*; do
  source "$rc"
done

# autoload common functions:
__function_dir="$SHELL_RESOURCES/functions"
fpath=( "$__function_dir" $fpath )
autoload "$__function_dir"/*(:t) 2>/dev/null

# Emacs keybindings for the shell
bindkey -e

# completion
autoload -U compinit
compinit

# correction
setopt correctall

# prompt
autoload -U promptinit
promptinit
prompt walters

autoload colors
colors
setopt prompt_subst

# If a pattern doesn't glob, use it verbatim in the command
unsetopt nomatch

# Print the exit value if failure.
setopt print_exit_value

# For oh-my-zsh
#export ZSH=$HOME/.zsh.d/oh-my-zsh
#export ZSH_THEME="filcab"
##export ZSH_THEME="mortalscumbag"
## Maybe also add the extract plugin...
#plugins=(brew git svn macports osx)
## for now, make our ~/.zsh.d the custom dir for oh-my-zsh
#export ZSH_CUSTOM=$HOME/.zsh.d
#source $ZSH/oh-my-zsh.sh

# C-w should stop deleting at / and other similar boundaries
autoload -U select-word-style
select-word-style bash

# case-insensitive (all),partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# verbose completion
zstyle ':completion:*' verbose yes

# v From oh-my-zsh
# Save the location of the current completion dump file.
ZSH_COMPDUMP="${ZDOTDIR:-${HOME}}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"

# Load and run compinit
autoload -U compinit
compinit -i -d "${ZSH_COMPDUMP}"

# ^ From oh-my-zsh

for f in "$SHELL_RESOURCES"/zsh/lib/*.zsh; do
  source $f
done

# Load additional zsh stuff
for f in "$SHELL_RESOURCES"/zsh/rc.*; do
  source $f
done
