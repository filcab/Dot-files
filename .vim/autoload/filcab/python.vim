let filcab#python#initted = v:false
function filcab#python#init() abort
  if g:filcab#python#initted
    return
  endif

  packadd python-mode

  let filcab#python#completer_flavour = 'none'
  if executable('pyls')
    echo "Setting up vim-lsp for Python"
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
    echo "Setting up YouCompleteMe for Python"
    packadd YouCompleteMe
    let filcab#python#completer_flavour = 'ycm'
  endif

  let g:filcab#python#initted = v:true
endfunction
