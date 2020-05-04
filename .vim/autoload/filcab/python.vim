let filcab#python#initted = v:false
let filcab#python#completer_flavours = []
function filcab#python#init() abort
  if g:filcab#python#initted
    return
  endif

  " no need to manually run python-mode/ftplugin/python/*.vim, as the files in
  " FILETYPE directory are sourced after the FILETYPE.vim ones
  packadd python-mode

  if !get(g:, 'disable_lsp', v:false) && executable('pyls')
    echo "Setting up vim-lsp for Python"
    call add(g:filcab#python#completer_flavours, 'lsp')
    " If another language plugin uses YouCompleteMe, let's blacklist this type
    "let g:ycm_filetype_blacklist['python'] = 1
    packadd async
    packadd vim-lsp
    " pip install python-language-server
    call lsp#register_server({
      \ 'name': 'pyls',
      \ 'cmd': {server_info->['pyls']},
      \ 'whitelist': ['python'],
      \ })
  endif

  if !get(g:, 'disable_youcompleteme', v:false)
    echo "Setting up YouCompleteMe for Python"
    call add(g:filcab#python#completer_flavours, 'ycm')
    packadd YouCompleteMe
  endif

  let g:filcab#python#initted = v:true
endfunction
