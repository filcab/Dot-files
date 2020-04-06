let filcab#python#initted = v:false
let filcab#python#completer_flavour = 'none'
function filcab#python#init() abort
  if g:filcab#python#initted
    return
  endif

  packadd python-mode

  if v:false && executable('pyls')
    echo "Setting up vim-lsp for Python"
    let g:filcab#python#completer_flavour = 'lsp'
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
  elseif !g:disable_youcompleteme
    echo "Setting up YouCompleteMe for Python"
    packadd YouCompleteMe
    let g:filcab#python#completer_flavour = 'ycm'
  endif

  let g:filcab#python#initted = v:true
endfunction
