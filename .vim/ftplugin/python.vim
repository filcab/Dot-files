" Adjust black's virtualenv directory as we might end up hitting the same
" directory from several different vim executables
let g:black_virtualenv = $MYVIMRUNTIME . '/black'
if has('win32unix')
  let g:black_virtualenv .= '_win32unix'
elseif has('win32')
  let g:black_virtualenv .= '_win32'
elseif has('unix')
  let g:black_virtualenv .= '_unix'
endif

call filcab#python#init()
