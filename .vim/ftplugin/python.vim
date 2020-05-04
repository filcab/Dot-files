" Set python mode to python3 if available
if has('python3') || has('python3/dyn')
  let g:pymode_python = 'python3'
endif

call filcab#python#init()
