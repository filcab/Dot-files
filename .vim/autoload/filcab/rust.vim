let filcab#rust#initted = v:false
let filcab#rust#completer_flavours = []
function filcab#rust#init() abort
  if g:filcab#rust#initted
    return
  endif

  packadd vim-rust
  if get(s:, 'first_call', v:true)
    " If we've just added the vim-rust package, we need to make sure we're
    " loading the ftplugin from it. Since we add the package whilst in an
    " ftplugin, we need to source these manually
    runtime! OPT "vim-rust/ftplugin/rust.vim" "vim-rust/ftplugin/rust/*.vim"
    let s:first_call = v:false
  endif

  if !get(g:, 'disable_lsp', v:false) && executable('rls')
    echo "Setting up vim-lsp for Rust"
    call add(g:filcab#rust#completer_flavours, 'lsp')
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
    call filcab#packaddYCM()
  endif

  let g:filcab#rust#initted = v:true
endfunction
