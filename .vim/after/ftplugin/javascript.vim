if exists("b:did_filcab_after_js_ftplugin")
  finish
endif

call filcab#completers#setup_mappings('javascript')
if index(g:filcab#javascript#completer_flavours, 'lsp') != -1
  setlocal omnifunc=lsp#complete
endif

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

function! FilcabJavascriptFtPluginUndo()
  call filcab#completers#setup_mappings('javascript', v:true)
  setlocal omnifunc<
  nunmap <buffer> <LocalLeader><Tab>
  vunmap <buffer> <LocalLeader><Tab>
  iunmap <buffer> <C-Tab><Tab>
endfunction

" Add to the rest of the undo_ftplugin commands
let b:undo_ftplugin .= "|call FilcabJavascriptFtPluginUndo()"
let b:did_filcab_after_js_ftplugin = 1
