if exists("b:did_filcab_after_rust")
  finish
endif

if get(g:, 'lsp_impl', '') == 'vim-lsp'
  setlocal omnifunc=lsp#complete
endif

nnoremap <buffer><unique> <LocalLeader><Tab> :RustFmt<cr>
vnoremap <buffer><unique> <LocalLeader><Tab> :RustFmtRange<cr>
inoremap <buffer><unique> <C-Tab><Tab> <C-o>:RustFmtRange<cr><cr>

let b:undo_ftplugin .= '|setlocal omnifunc<'
function! FilcabRustFtPluginUndo()
  call filcab#completers#setup_mappings('rust', v:true)
  setlocal omnifunc<
  nunmap <buffer> <LocalLeader><Tab>
  vunmap <buffer> <LocalLeader><Tab>
  iunmap <buffer> <C-Tab><Tab>
endfunction

" Add to the rest of the undo_ftplugin commands
let b:undo_ftplugin .= "|call FilcabRustFtPluginUndo()"
let b:did_filcab_after_rust = 1
