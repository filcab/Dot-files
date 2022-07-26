if exists("b:did_filcab_after_python_ftplugin")
  finish
endif

call filcab#lsp#ftplugin()

if get(g:, 'lsp_impl', '') == 'vim-lsp'
  setlocal omnifunc=lsp#complete
elseif get(g:, 'lsp_impl', '') == ''
  noremap <buffer><unique> <LocalLeader><Tab> :Black<cr>
endif

" black's default text width is 88
setlocal textwidth=88
let g:pymode_options_max_line_length = &textwidth
let g:pymode_lint_options_pep8 = {'max_line_length': g:pymode_options_max_line_length}


let s:undo_ftplugin = 'setlocal omnifunc< textwidth< | nunmap <buffer> <LocalLeader><Tab>'
if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'.s:undo_ftplugin
else
  let b:undo_ftplugin = s:undo_ftplugin
endif
let b:did_filcab_after_python_ftplugin = 1
