if exists("b:did_filcab_python")
  finish
endif
let b:did_filcab_python = 1

call filcab#python#init()
call filcab#completers#setup_mappings('python')

if g:filcab#python#completer_flavour == 'lsp'
  setlocal omnifunc=lsp#complete
endif

" black's default text width is 88
setlocal textwidth=88
let g:pymode_options_max_line_length=88
let g:pymode_lint_options_pep8 = {'max_line_length': g:pymode_options_max_line_length}

" Set python mode to python3 if available
if has('python3') || has('python3/dyn')
  let g:pymode_python = 'python3'
endif

noremap <buffer><unique> <LocalLeader><Tab> :Black<cr>
