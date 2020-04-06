" This file will also be sourced by the cpp ftplugin
if exists("b:did_filcab_c_ftplugin")
  finish
endif
let b:did_filcab_c_ftplugin = 1

call filcab#c#init()
call filcab#completers#setup_mappings('c')

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

nnoremap <buffer><silent><unique> <F5> :call filcab#c#ClangCheck()<CR><CR>

" Setup clang-format on save functionality only in C/C++ files
autocmd BufWritePre <buffer>
  \ if get(b:, 'clang_format_on_save', g:clang_format_on_save) |
  \   call filcab#c#ClangFormat() |
  \ endif

" Tell ycm about clangd (must be after we've ensured the autoload, which sets
" g:clangd_path)
let g:ycm_clangd_binary_path = g:clangd_path
