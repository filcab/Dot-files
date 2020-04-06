call filcab#javascript#init()

" clang-format integration
if has('python3')
  nnoremap <buffer><unique> <LocalLeader><Tab> :py3f ~/.vim/clang-format.py<cr>
  vnoremap <buffer><unique> <LocalLeader><Tab> :py3f ~/.vim/clang-format.py<cr>
  inoremap <buffer><unique> <C-Tab><Tab> <C-o>:py3f ~/.vim/clang-format.py<cr><cr>
elseif has('python')
  nnoremap <buffer><unique> <LocalLeader><Tab> :pyf ~/.vim/clang-format.py<cr>
  vnoremap <buffer><unique> <LocalLeader><Tab> :pyf ~/.vim/clang-format.py<cr>
  inoremap <buffer><unique> <C-Tab><Tab> <C-o>:pyf ~/.vim/clang-format.py<cr><cr>
else
  echom 'Python3/Python not available, skipping clang-format mappings'
endif

call filcab#completers#setup_mappings('javascript')
