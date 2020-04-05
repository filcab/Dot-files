let filcab#python#completer_flavour = 'none'
if executable('pyls')
  let filcab#python#completer_flavour = 'lsp'
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
elseif !g:disable_youcompleteme
  packadd YouCompleteMe
  let filcab#python#completer_flavour = 'ycm'
endif

" Dummy function to ensure this file is loaded
function filcab#python#ensure_loaded()
endfunction
