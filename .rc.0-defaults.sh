source ~/.paths

### Setup basic aliases
alias cd..='cd ..'
alias less='less -r'
alias grep='grep --color=auto'
case $(uname -s) in
  Darwin)
    alias ls='ls -FG'
    alias ldd='otool -L'
    ;;
  linux|MINGW*)
    alias ls="ls -F --color"
    ;;
esac

### Vim and $EDITOR
if [ -z "$EDITOR" ] && hash vim &> /dev/null; then
  export EDITOR=vim
fi

## old EDITOR
# Use emacsclient as an EDITOR. Spawn a new emacs --daemon if it isn't running
#export EDITOR="emacsclient -t"
#export ALTERNATE_EDITOR=""

case $(uname -s) in
  Darwin)
    # Have we brewed a vim?
    if [ -f ~/dev/brew/bin/vim -a -x ~/dev/brew/bin/vim ]; then
      export EDITOR=~/dev/brew/bin/vim
    fi
    ;;
  MINGW*)
    # Have we installed a more current vim? (We're assuming we have msys git, which has an old vim)
    if [ -f /c/Program\ Files/Vim/vim81/vim.exe ]; then
      # Also alias vim/gvim so we get the updated version in most places
      alias vim="winpty /c/Program\ Files/Vim/vim81/vim.exe"
      alias view="winpty /c/Program\ Files/Vim/vim81/view.exe"
      alias vimdiff="vim -d"
      alias gvim="/c/Program\ Files/Vim/vim81/gvim.exe"
      alias gview="winpty /c/Program\ Files/Vim/vim81/gview.exe"
      alias gvimdiff="gvim -d"
      export EDITOR="winpty /c/Program\ Files/Vim/vim81/vim.exe"
    fi
    ;;
esac

### Git
# gg alias plus v alias to do the previous line with vgg (script in
# ~/.zsh.d/bin), which opens the output of git grep in vim, as a location
# list.
alias gg='git grep'
alias v='eval "v$(fc -l -n -1)"'

### Set better defaults for miscellaneous environment variables
# Colorize 'ls' command output
export CLICOLOR=1

# So ctest shows us the output if a test failed
export CTEST_OUTPUT_ON_FAILURE=1

# Use native symlinks on Windows by default. Assumes we have perms for that, which needs to be done once per machine
case $(uname -s) in
  MINGW*)
    export MSYS=winsymlinks:nativestrict
    ;;
esac

# Color for manpages:
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_us=$'\E[01;32m'
# Use a reset code as the last definition
export LESS_TERMCAP_ue=$'\E[0m'

### Load ssh-agent settings or start it and export its settings
function maybe_start_ssh_agent {
  local env=~/.ssh/agent.env

  agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

  agent_start () {
      (umask 077; ssh-agent >| "$env")
      . "$env" >| /dev/null ; }

  agent_load_env

  # agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
  agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

  if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
      agent_start
      ssh-add
  elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
      ssh-add
  fi
}

maybe_start_ssh_agent

### Setup PS1
# Don't setup a colourful PS1 if we're on a shell within emacs
if [ -z "$EMACSPATH"]; then
  export PS1='[\[\033[01;32m\]\u\[\033[00m\]@\[\033[01;31m\]\h\[\033[01;34m\] \w\[\033[00m\]] \$ '
fi

### Use vimpager if available
if type vimpager &>/dev/null;
then
  export PAGER=vimpager
else
  export PAGER="less -R"
fi

### Ninja status: "time [left/running/finished]"
export NINJA_STATUS="$(tput bold)%e$(tput sgr0) [$(tput bold)$(tput setaf 1)%u$(tput sgr0)/$(tput bold)$(tput setaf 3)%r$(tput sgr0)/$(tput bold)$(tput setaf 2)%f$(tput sgr0)] "

### Homebrew settings
# Always build from source
export HOMEBREW_BUILD_FROM_SOURCE=1
# No analytics
export HOMEBREW_NO_ANALYTICS=1

### Disable the creepy, unacceptable, stats requests by CocoaPods
export COCOAPODS_DISABLE_STATS=1

case "$SHELL" in
  *bash|*bash.exe)
    # Special-case this script, for now, as it works on both
    source ~/.zsh.d/lib/git-prompt.zsh
    ;;
esac

