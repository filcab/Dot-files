call filcab#python#init()
call filcab#lsp#ftplugin()

" search for trailing whitespace, don't set the cursor to the found position
" returns 0 if not found, line number if found. set pymode_trim_whitespaces to
" true if we *already* are clean of trailing whitespace
" flags: don't move the cursor 'n', wrap around the file 'w'
let found_trailing_ws = search('\s\+$', 'nw')
if found_trailing_ws
  echom "Trailing whitespace found at line" found_trailing_ws "disabling trim_whitespace"
endif
let b:pymode_trim_whitespaces = !found_trailing_ws
