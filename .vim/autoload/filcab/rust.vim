let filcab#rust#initted = v:false
let filcab#rust#completer_flavour = 'none'
function filcab#rust#init() abort
  if g:filcab#rust#initted
    return
  endif

  packadd vim-rust

  if executable('rls')
    echo "Setting up vim-lsp for Rust"
    let g:filcab#rust#completer_flavour = 'lsp'
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
  endif

  if !g:disable_youcompleteme
    echo "Setting up YouCompleteMe for Rust"
    let g:filcab#rust#completer_flavour = 'ycm'
    packadd YouCompleteMe
  endif

  let g:filcab#rust#initted = v:true
endfunction
