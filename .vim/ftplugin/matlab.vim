" add a command to open the terminal with octave-cli
" we want to call the vbscript as it sets up the required environment
" variables

" TODO: Allow me to send visual selections to the buffer
command! OctaveREPL call filcab#matlab#openOctaveREPL()
noremap <leader>r <Cmd>OctaveREPL<cr>
