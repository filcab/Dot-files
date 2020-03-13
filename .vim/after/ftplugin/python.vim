if exists("b:did_filcab_python")
  finish
endif
let b:did_filcab_python = 1

" black's default text width is 88
setlocal textwidth=88

" Set python mode to python3 if available
if has('python3') || has('python3/dyn')
  let g:pymode_python = 'python3'
endif

noremap <buffer><unique> <LocalLeader><Tab> :Black<cr>
