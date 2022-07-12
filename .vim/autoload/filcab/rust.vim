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

  let g:ycm_rust_src_path = system('rustc +nightly --print sysroot')->trim()

  if g:ycm_rust_src_path == ''
    " don't set initted to v:true so we try searching for rust-analyzer again
    return
  endif

  if get(g:, 'ycm_enable', v:false)
    echo "Setting up YouCompleteMe for Rust"
    call add(g:filcab#rust#completer_flavours, 'ycm')
    call filcab#packaddYCM()
  elseif get(g:, 'lsp_enable', v:false)
    echo "Setting up vim-lsp for Rust"
    call add(g:filcab#rust#completer_flavours, 'lsp')
    packadd vim-lsp
    call lsp#register_server({
      \ 'name': 'rust-analyzer',
      \ 'cmd': {server_info->['rustup', '+nightly', 'run', 'rust-analyzer']},
      \ 'whitelist': ['rust'],
      \ })
  endif

  let g:filcab#rust#initted = v:true
endfunction
