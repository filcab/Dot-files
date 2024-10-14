if get(b:, "did_filcab_after_python_ftplugin", 0)
  finish
endif

if get(g:, 'lsp_impl', '') == 'vim-lsp'
  setlocal omnifunc=lsp#complete
elseif get(g:, 'lsp_impl', '') == ''
  silent! noremap <buffer><unique> <LocalLeader><Tab> :Black<cr>
  " default vim plugins have a decent function, it seems
  setlocal omnifunc=python3complete#Complete
  " python-mode also has some completion stuff
endif

let s:undo_ftplugin = 'setlocal omnifunc< textwidth< | silent! unmap <buffer> <LocalLeader><Tab> | unlet b:did_filcab_after_python_ftplugin'
if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'.s:undo_ftplugin
else
  let b:undo_ftplugin = s:undo_ftplugin
endif
let b:did_filcab_after_python_ftplugin = 1
