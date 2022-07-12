let filcab#javascript#initted = v:false
let filcab#javascript#completer_flavours = []
function filcab#javascript#init() abort
  if g:filcab#javascript#initted
    return
  endif

  if get(g:, 'ycm_enable', v:false)
    echo "Setting up YouCompleteMe for Javascript"
    call add(g:filcab#javascript#completer_flavours, 'ycm')
    call filcab#packaddYCM()
  elseif get(g:, 'lsp_enable', v:false) && executable('javascript-typescript-langserver')
    echo "Setting up vim-lsp for Javascript"
    call add(g:filcab#javascript#completer_flavours, 'lsp')
    " pip install python-language-server
    call lsp#register_server({
      \ 'name': 'tern',
      \ 'cmd': {server_info->['javascript-typescript-langserver']},
      \ 'whitelist': ['javascript'],
      \ })
  endif

  let g:filcab#javascript#initted = v:true
endfunction
