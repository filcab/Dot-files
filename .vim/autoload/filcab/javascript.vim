let filcab#javascript#initted = v:false
let filcab#javascript#completer_flavours = []

function filcab#javascript#init() abort
  if g:filcab#javascript#initted
    return
  endif

  call filcab#lsp#setup()
  if get(g:, 'lsp_impl', '') == "vim-lsp" && executable('javascript-typescript-langserver')
    call lsp#register_server({
      \ 'name': 'tern',
      \ 'cmd': {server_info->['javascript-typescript-langserver']},
      \ 'whitelist': ['javascript'],
      \ })
  endif

  let g:filcab#javascript#initted = v:true
endfunction
