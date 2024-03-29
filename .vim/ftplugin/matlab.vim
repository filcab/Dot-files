" add a command to open the terminal with octave-cli
" we want to call the vbscript as it sets up the required environment
" variables

" TODO: Allow me to send visual selections to the buffer
command! REPLOctaveFocus call filcab#matlab#openOctaveREPL()
command! REPLOctaveSend call filcab#matlab#sendToOctaveREPL()
" command! -range REPLOctaveSendRange <line1>,<line2>call filcab#matlab#sendToOctaveREPL()

" normal only, as visual probably doesn't want to lose the selection?
nnoremap <unique><buffer> <localleader>r <Cmd>REPLOctaveFocus<cr>

" e for eval... as a fallback is <enter> is being weird
noremap <unique><buffer> <localleader>e <Cmd>REPLOctaveSend<cr>
noremap <unique><buffer> <localleader><enter> <Cmd>REPLOctaveSend<cr>

" one of the few free keys in insert mode:
" https://vim.fandom.com/wiki/Unused_keys
inoremap <unique><buffer> <C-B><enter> <Cmd>REPLOctaveSend<cr>
