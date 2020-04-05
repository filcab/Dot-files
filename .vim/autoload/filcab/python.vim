if executable('pyls')
  let filcab#python#found_lsp = 1
  " If another language plugin uses YouCompleteMe, let's blacklist this type
  let g:ycm_filetype_blacklist['python'] = 1
  packadd async
  packadd vim-lsp
  " pip install python-language-server
  call lsp#register_server({
          \ 'name': 'pyls',
          \ 'cmd': {server_info->['pyls']},
          \ 'whitelist': ['python'],
          \ })
  autocmd FileType python setlocal omnifunc=lsp#complete
else
  let filcab#python#found_lsp = 0
endif

if !filcab#python#found_lsp && !g:disable_youcompleteme
  packadd YouCompleteMe
endif

" Dummy function to ensure this file is loaded
function filcab#python#ensure_loaded()
endfunction
