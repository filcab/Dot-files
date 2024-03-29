set cmdheight=2

" Use space as the leader as it's much more accessible, especially in UK
" keyboards (and US Mac keyboards on Windows)
let mapleader = ' '

" I've been trying out tabs for a few things... let's see if this pans out
" The only of [] {} () where neither char is bound in default C-w sequences is ()
nnoremap <unique> <c-w>( <Cmd>tabprev<cr>
nnoremap <unique> <c-w>) <Cmd>tabnext<cr>
" escape to EX mode first
tnoremap <unique> <c-w>( <Cmd>tabprev<cr>
tnoremap <unique> <c-w>) <Cmd>tabnext<cr>
xnoremap <unique> <c-w>( <Cmd>tabprev<cr>
xnoremap <unique> <c-w>) <Cmd>tabnext<cr>

" Remove line numbers in :terminal buffers (when in normal mode)
augroup filcabTerminal
  autocmd!
  autocmd TerminalOpen * setlocal nonumber
augroup END

" make it easier to know which line we're on
" cursorline ends up behaving in funky ways in some colorthemes.
" Maybe think about bringing it back after we think about how to fix it.
" Anyway, backgrounds are likely to disappear for the cursorline line
"set cursorline
" add bold attribute to current line number when 'number' and 'cursorline' are
" set
set highlight+=Nb
" " alternative, for when we have set 'relativenumber' (don't want this in
" " general, as we're changing the number highlight for all numbers to bold,
" " then putting back the regular highlights for numbers before and after the
" " current line
" " set line numbers to have the bold attribute (on top of LineNr highlight group)
" set highlight+=nb
" " revert lines above and below the current line to the LineNr highlight group
" " (assumes it's not bold)
" set highlight+=a:LineNr
" set highlight+=b:LineNr

if executable("fzf")
  call filcab#fzf#install_fzf_and_keybindings()
endif
