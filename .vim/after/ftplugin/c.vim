" This file will also be sourced by the cpp ftplugin
if exists("b:did_filcab_after_c_ftplugin")
  finish
endif

call filcab#completers#setup_mappings('c')
if index(g:filcab#c#completer_flavours, 'lsp') != -1
  " YCM doesn't use omnifunc, so this allows us to have YCM and LSP at the
  " same time
  setlocal omnifunc=lsp#complete
endif

nnoremap <buffer><silent><unique> <F5> :call filcab#c#ClangCheck()<CR><CR>

" clang-format integration
if has('python3')
  nnoremap <buffer><unique> <LocalLeader><Tab> :py3f $MYVIMRUNTIME/clang-format.py<cr>
  vnoremap <buffer><unique> <LocalLeader><Tab> :py3f $MYVIMRUNTIME/clang-format.py<cr>
  inoremap <buffer><unique> <C-Tab><Tab> <C-o>:py3f $MYVIMRUNTIME/clang-format.py<cr><cr>
elseif has('python')
  nnoremap <buffer><unique> <LocalLeader><Tab> :pyf $MYVIMRUNTIME/clang-format.py<cr>
  vnoremap <buffer><unique> <LocalLeader><Tab> :pyf $MYVIMRUNTIME/clang-format.py<cr>
  inoremap <buffer><unique> <C-Tab><Tab> <C-o>:pyf $MYVIMRUNTIME/clang-format.py<cr><cr>
else
  echom 'Python3/Python not available, skipping clang-format mappings'
endif

" Setup clang-format on save functionality only in C/C++ files
augroup FilcabCFtAutoCommands
  autocmd!
  autocmd BufWritePre <buffer>
    \ if get(b:, 'clang_format_on_save', g:clang_format_on_save) |
    \   call filcab#ClangFormat() |
    \ endif
augroup END

function! FilcabCFtPluginUndo()
  call filcab#completers#setup_mappings('c', v:true)
  setlocal omnifunc<
  nunmap <buffer> <LocalLeader><Tab>
  vunmap <buffer> <LocalLeader><Tab>
  iunmap <buffer> <C-Tab><Tab>
  nunmap <buffer> <F5>
  autocmd! FilcabCFtAutoCommands
endfunction

" Add to the rest of the undo_ftplugin commands
let b:undo_ftplugin .= "|call FilcabCFtPluginUndo()"
let b:did_filcab_after_c_ftplugin = 1
