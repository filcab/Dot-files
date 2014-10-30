# Most of this file came from robbyrussell's oh-my-zsh:
# https://github.com/robbyrussell/oh-my-zsh
#
alias man='nocorrect man'
alias mv='nocorrect mv'
alias mkdir='nocorrect mkdir'
alias gist='nocorrect gist'
alias sudo='nocorrect sudo'

if [[ "$ENABLE_CORRECTION" == "true" ]]; then
  setopt correct_all
fi

