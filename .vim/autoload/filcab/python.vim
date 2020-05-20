let filcab#python#initted = v:false
let filcab#python#completer_flavours = []
function filcab#python#init() abort
  if g:filcab#python#initted
    return
  endif

  if !get(g:, 'disable_lsp', v:false) && executable('pyls')
    echo "Setting up vim-lsp for Python"
    call add(g:filcab#python#completer_flavours, 'lsp')
    " pip install python-language-server
    call lsp#register_server({
      \ 'name': 'pyls',
      \ 'cmd': {server_info->['pyls']},
      \ 'whitelist': ['python'],
      \ })
    call lsp#enable()
  endif

  if !get(g:, 'disable_youcompleteme', v:false)
    echo "Setting up YouCompleteMe for Python"
    call add(g:filcab#python#completer_flavours, 'ycm')
    call filcab#packaddYCM()
  endif

  let g:filcab#python#initted = v:true
endfunction
