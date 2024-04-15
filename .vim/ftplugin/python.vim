compiler pyunit

" these pymode overrides are safe to do before initializing it, so let's keep
" it here instead of after/ftplugin/python
" black's default text width is 88, let's use that
setlocal textwidth=88
let g:pymode_options_max_line_length = &textwidth

" search for trailing whitespace, don't set the cursor to the found position
" returns 0 if not found, line number if found. set pymode_trim_whitespaces to
" true if we *already* are clean of trailing whitespace
" flags: don't move the cursor 'n', wrap around the file 'w'
let found_trailing_ws = search('\s\+$', 'nw')
if found_trailing_ws
  echom "Trailing whitespace found at line" found_trailing_ws "disabling trim_whitespace"
endif
let b:pymode_trim_whitespaces = !found_trailing_ws

call filcab#python#init()
call filcab#lsp#ftplugin()
