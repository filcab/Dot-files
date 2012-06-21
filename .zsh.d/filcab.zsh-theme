# PROMPT='%{$fg_bold[red]%}➜ %{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
# 
# ZSH_THEME_GIT_PROMPT_PREFIX="±:(%{$fg[red]%}"
# ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_CLEAN=""
# 
# FC_GIT_PAREN="%{$fg[blue]%})"
# ZSH_THEME_GIT_PROMPT_DIRTY="$FC_GIT_PAREN %{$fg[green]%}!"
# ZSH_THEME_GIT_PROMPT_UNTRACKED="$FC_GIT_PAREN %{$fg[green]%}?"
# ZSH_THEME_GIT_PROMPT_CLEAN="$FC_GIT_PAREN"


# Based on Steve Losh's extravagant zsh prompt:
# http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt


function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    in_svn >/dev/null 2>/dev/null && echo '⚡' && return
    echo '○'
}

function hg_prompt_info {
    hg prompt --angle-brackets "\
< on %{$fg[magenta]%}<branch>%{$reset_color%}>\
< at %{$fg[yellow]%}<tags|%{$reset_color%}, %{$fg[yellow]%}>%{$reset_color%}>\
%{$fg[green]%}<status|modified|unknown><update>%{$reset_color%}<
patches: <patches|join( → )|pre_applied(%{$fg[yellow]%})|post_applied(%{$reset_color%})|pre_unapplied(%{$fg_bold[black]%})|post_unapplied(%{$reset_color%})>>" 2>/dev/null
}

function prompt_date {
  date +"%a, %d %b %Y (%H:%m)"
}

# Override the function to deal with llvm repos
function svn_get_repo_name {
    if in_svn; then
        svn info | sed -n 's/Repository\ Root:\ .*\///p' | read SVN_ROOT
        svn info | sed -n "s/URL:\ .*$SVN_ROOT\///p" | read SVN_DIR

        echo $SVN_DIR | sed -e 's-/trunk--' | read SVN_DIR
        echo $SVN_DIR | sed -e "s-/branches/\(.*\)\$-%{$reset_color%}($ZSH_THEME_SVN_PROMPT_BRANCH_COLOR\1%{$reset_color%})-"
    fi
}

PROMPT='%{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in %{$fg_bold[green]%}%~%{$reset_color%}$(hg_prompt_info)$(git_prompt_info)$(svn_prompt_info)
%(?..%{$reset_prompt%}[%{$fg[red]%}%?%{$reset_color%}] )$(prompt_char) '

#RPROMPT='$(battery-charge)'
RPROMPT='%{$fg[blue]%}[%{$reset_color%}%D{%a, %d %b %Y (%H:%M)}%{$fg[blue]%}]%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_SVN_PROMPT_PREFIX=" on %{$fg[magenta]%}"
ZSH_THEME_SVN_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_SVN_PROMPT_BRANCH_COLOR="%{$fg[yellow]%}"

#ZSH_THEME_REPO_NAME_COLOR="%{$fg[yellow]%}"
#ZSH_PROMPT_BASE_COLOR="%{$reset_color%}"
