let filcab#rust#initted = v:false
let filcab#rust#completer_flavours = []
function filcab#rust#init() abort
  if g:filcab#rust#initted
    return
  endif

  packadd vim-rust

  if !get(g:, 'disable_lsp', v:false) && executable('rls')
    echo "Setting up vim-lsp for Rust"
    call add(g:filcab#rust#completer_flavours, 'lsp')
    " If another language plugin uses YouCompleteMe, let's blacklist this type
    "let g:ycm_filetype_blacklist['rust'] = 1
    packadd async
    packadd vim-lsp
    " cargo install rls
    call lsp#register_server({
      \ 'name': 'rls',
      \ 'cmd': {server_info->['rls']},
      \ 'whitelist': ['rust'],
      \ })
  endif

  if !get(g:, 'disable_youcompleteme', v:false)
    echo "Setting up YouCompleteMe for Rust"
    let g:ycm_rls_binary_path='rls'
    let g:ycm_rustc_binary_path='rustc'
    call add(g:filcab#rust#completer_flavours, 'ycm')
    packadd YouCompleteMe
  endif

  let g:filcab#rust#initted = v:true
endfunction
