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

" Dummy function to ensure this file is loaded
function filcab#rust#ensure_loaded()
endfunction
