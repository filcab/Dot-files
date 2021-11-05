" add a command to open the terminal with octave-cli
" we want to call the vbscript as it sets up the required environment
" variables

" TODO: Allow me to send visual selections to the buffer
command! REPLOctaveFocus call filcab#matlab#openOctaveREPL()
command! REPLOctaveSend call filcab#matlab#sendToOctaveREPL()
" command! -range REPLOctaveSendRange <line1>,<line2>call filcab#matlab#sendToOctaveREPL()

" normal only, as visual probably doesn't want to lose the selection?
nnoremap <localleader>r <Cmd>REPLOctaveFocus<cr>

" e for eval... as a fallback is <enter> is being weird
noremap <localleader>e <Cmd>REPLOctaveSend<cr>
noremap <localleader><enter> <Cmd>REPLOctaveSend<cr>
