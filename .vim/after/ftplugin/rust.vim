call filcab#rust#init()
call filcab#completers#setup_mappings('rust')

if g:filcab#rust#completer_flavour == 'lsp'
  setlocal omnifunc=lsp#complete
endif

nnoremap <buffer><unique> <LocalLeader><Tab> :RustFmt<cr>
vnoremap <buffer><unique> <LocalLeader><Tab> :RustFmtRange<cr>
inoremap <buffer><unique> <C-Tab><Tab> <C-o>:RustFmtRange<cr><cr>
