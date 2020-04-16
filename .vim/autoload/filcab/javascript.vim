let filcab#javascript#initted = v:false
let filcab#javascript#completer_flavours = []
function filcab#javascript#init() abort
  if g:filcab#javascript#initted
    return
  endif

  if !get(g:, 'disable_lsp', v:false) && executable('javascript-language-server')
    echo "Setting up vim-lsp for Javascript"
    call add(g:filcab#javascript#completer_flavours, 'lsp')
    " If another language plugin uses YouCompleteMe, let's blacklist this type
    "let g:ycm_filetype_blacklist['javascript'] = 1
    " pip install python-language-server
    call lsp#register_server({
      \ 'name': 'tern',
      \ 'cmd': {server_info->['tern']},
      \ 'whitelist': ['javascript'],
      \ })
  endif

  if !get(g:, 'disable_youcompleteme', v:false)
    echo "Setting up YouCompleteMe for Javascript"
    call add(g:filcab#javascript#completer_flavours, 'ycm')
    packadd YouCompleteMe
  endif

  let g:filcab#javascript#initted = v:true
endfunction
