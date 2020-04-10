# Most of this file came from robbyrussell's oh-my-zsh:
# https://github.com/robbyrussell/oh-my-zsh
#
## smart urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

## file rename magick
bindkey "^[m" copy-prev-shell-word

## jobs
setopt long_list_jobs

## pager
#export PAGER="less"
#export LESS="-R"
#
#export LC_CTYPE=$LANG

