if exists("b:did_filcab_after_python")
  finish
endif

call filcab#completers#setup_mappings('python')
if index(g:filcab#python#completer_flavours, 'lsp') != -1
  setlocal omnifunc=lsp#complete
endif

" black's default text width is 88
setlocal textwidth=88
let g:pymode_options_max_line_length=88
let g:pymode_lint_options_pep8 = {'max_line_length': g:pymode_options_max_line_length}

noremap <buffer><unique> <LocalLeader><Tab> :Black<cr>

let s:undo_ftplugin = 'setlocal omnifunc< textwidth< | nunmap <buffer> <LocalLeader><Tab>'
if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'.s:undo_ftplugin
else
  let b:undo_ftplugin = s:undo_ftplugin
endif
let b:did_filcab_after_python = 1
