let filcab#javascript#initted = v:false
let filcab#javascript#completer_flavour = 'none'
function filcab#javascript#init() abort
  if g:filcab#javascript#initted
    return
  endif

  if v:false && executable('javascript-language-server')
    echo "Setting up vim-lsp for Javascript"
    let g:filcab#javascript#completer_flavour = 'lsp'
    " If another language plugin uses YouCompleteMe, let's blacklist this type
    let g:ycm_filetype_blacklist['javascript'] = 1
    " pip install python-language-server
    call lsp#register_server({
      \ 'name': 'tern',
      \ 'cmd': {server_info->['tern']},
      \ 'whitelist': ['javascript'],
      \ })
    autocmd FileType javascript setlocal omnifunc=lsp#complete
  elseif !g:disable_youcompleteme
    echo "Setting up YouCompleteMe for Javascript"
    packadd YouCompleteMe
    let g:filcab#javascript#completer_flavour = 'ycm'
  endif

  let g:filcab#javascript#initted = v:true
endfunction

