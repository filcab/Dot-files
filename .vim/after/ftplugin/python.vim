if get(b:, "did_filcab_after_python_ftplugin", 0)
  finish
endif

if get(g:, 'lsp_impl', '') == 'vim-lsp'
  setlocal omnifunc=lsp#complete
elseif get(g:, 'lsp_impl', '') == ''
  noremap <buffer><unique> <LocalLeader><Tab> :Black<cr>
endif

" black's default text width is 88
setlocal textwidth=88
let g:pymode_options_max_line_length = &textwidth
let g:pymode_lint_options_pep8 = {'max_line_length': g:pymode_options_max_line_length}

" search for trailing whitespace, don't set the cursor to the found position
" returns 0 if not found, line number if found. set pymode_trim_whitespaces to
" true if we *already* are clean of trailing whitespace
" flags: don't move the cursor 'n', wrap around the file 'w'
let found_trailing_ws = search('\s\+$', 'nw')
if found_trailing_ws
  echom "Trailing whitespace found at line" found_trailing_ws "disabling trim_whitespace"
endif
let b:pymode_trim_whitespaces = !found_trailing_ws

let s:undo_ftplugin = 'setlocal omnifunc< textwidth< | nunmap <buffer> <LocalLeader><Tab> | unlet b:did_filcab_after_python_ftplugin'
if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'.s:undo_ftplugin
else
  let b:undo_ftplugin = s:undo_ftplugin
endif
let b:did_filcab_after_python_ftplugin = 1
