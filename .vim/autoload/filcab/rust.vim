if executable('rls')
  let filcab#rust#found_lsp = 1
  " If another language plugin uses YouCompleteMe, let's blacklist this type
  let g:ycm_filetype_blacklist['rust'] = 1
  packadd async
  packadd vim-lsp
  " cargo install rls
  call lsp#register_server({
          \ 'name': 'rls',
          \ 'cmd': {server_info->['rls']},
          \ 'whitelist': ['rust'],
          \ })
  autocmd FileType rust setlocal omnifunc=lsp#complete
else
  let filcab#rust#found_lsp = 0
endif

if !filcab#rust#found_lsp && !g:disable_youcompleteme
  packadd YouCompleteMe
endif

function filcab#rust#ToolMappings(...)
  " Bail out if the mappings have already been setup on this buffer
  if exists('b:filcab_setup_rust_tool_mappings')
    return
  endif

  nnoremap <buffer><unique> <LocalLeader><Tab> :RustFmt<cr>
  vnoremap <buffer><unique> <LocalLeader><Tab> :RustFmtRange<cr>
  inoremap <buffer><unique> <C-Tab><Tab> <C-o>:RustFmtRange<cr><cr>

  let b:filcab_setup_rust_tool_mappings=1
endfunction
