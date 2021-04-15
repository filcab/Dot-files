" test some keybindings for git rebase buffers
" these will allow us to easily see the commits
map <localleader>s 0W:Git show --stat <c-r>=expand('<cword>')<cr><cr>
map <localleader>d 0W:Git show <c-r>=expand('<cword>')<cr><cr>
