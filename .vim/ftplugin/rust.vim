call filcab#rust#init()
call filcab#completers#setup_mappings()

nnoremap <buffer><unique> <LocalLeader><Tab> :RustFmt<cr>
vnoremap <buffer><unique> <LocalLeader><Tab> :RustFmtRange<cr>
inoremap <buffer><unique> <C-Tab><Tab> <C-o>:RustFmtRange<cr><cr>
