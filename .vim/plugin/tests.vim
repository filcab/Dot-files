set cmdheight=2

" Use space as the leader as it's much more accessible, especially in UK
" keyboards (and US Mac keyboards on Windows)
let mapleader = ' '

" I've been trying out tabs for a few things... let's see if this pans out
" The only of [] {} () where neither char is bound in default C-w sequences is ()
" just skip any errors. If these aren't setup, I'll just use `verbose map` to
" see what happened
silent! nnoremap <unique> <c-w>( <Cmd>tabprev<cr>
silent! nnoremap <unique> <c-w>) <Cmd>tabnext<cr>
" escape to EX mode first
silent! tnoremap <unique> <c-w>( <Cmd>tabprev<cr>
silent! tnoremap <unique> <c-w>) <Cmd>tabnext<cr>
silent! xnoremap <unique> <c-w>( <Cmd>tabprev<cr>
silent! xnoremap <unique> <c-w>) <Cmd>tabnext<cr>

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

" from https://github.com/crux/crux-vimrc/blob/master/plugin/unicode.vim
" modify selected text using combining diacritics
command! -range -nargs=0 Overline        call s:CombineSelection(<line1>, <line2>, '0305')
command! -range -nargs=0 Underline       call s:CombineSelection(<line1>, <line2>, '0332')
command! -range -nargs=0 DoubleUnderline call s:CombineSelection(<line1>, <line2>, '0333')
command! -range -nargs=0 Strikethrough   call s:CombineSelection(<line1>, <line2>, '0336')

function! s:CombineSelection(line1, line2, cp)
  execute 'let char = "\u'.a:cp.'"'
  execute a:line1.','.a:line2.'s/\%V[^[:cntrl:]]/&'.char.'/ge'
endfunction

" interesting shortcuts, let's try them out
vnoremap  :Strikethrough<CR>
vnoremap __ :Underline<CR>
