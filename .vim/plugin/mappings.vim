if exists('g:loaded_mappings')
  finish
endif

" Map <LocalLeader> to , by default (was '\', same as <Leader>)
" need to do this before mapping both to different things, below
let maplocalleader=','

" Use space as the leader as it's much more accessible, especially in UK
" keyboards (and US Mac keyboards on Windows)
let mapleader = ' '

" terminal:  Use a mapping similar to tmux's copy-mode map to change to normal mode
tmap <c-w>[ <c-w>N

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  noremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" From TPope's sensible.vim
" When doing "delete to beginning of line" in insert mode, "break" undo first
" so we can easily recover from mistakes.
inoremap <C-U> <C-G>u<C-U>

""" Filcab
" All mappings should be unique so we know we're not clashing with built-in or
" other plugin mappings. This requires a workaround for autocmd, which is to
" go through a function to setup the mappings, and bailing out if they're
" already setup.
" Eventually this might be problematic if we keep switching filetype on the
" same buffer. Let's only fix that if it becomes a problem.

" Have <leader>d! do a missing :Dispatch binding
noremap <unique> <leader>d! :Dispatch!<cr>
" Also have one which needs no shift
noremap <unique> <leader>d1 :Dispatch!<cr>
" Also add regular <cr> terminated, for consistency (no benefit vs d<cr>)
noremap <unique> <leader>d<cr> :Dispatch<cr>

" use <leader>t to get to the first terminal window (if open, otherwise it's a
" no-op)
nnoremap <unique> <leader>t :GotoTerminalWindow<cr>

" Help for some bindings:
noremap <unique><expr> <Leader> '<Cmd>WhichKey "'.get(g:, 'mapleader', '\\').'"<cr>'
noremap <unique><expr> <LocalLeader> '<Cmd>WhichKey "'.g:maplocalleader.'"<cr>'
nnoremap <unique> [? <Cmd>WhichKey '['<cr>
nnoremap <unique> ]? <Cmd>WhichKey ']'<cr>
tnoremap <unique> [? <Cmd>WhichKey '['<cr>
tnoremap <unique> ]? <Cmd>WhichKey ']'<cr>
nnoremap <unique> <C-w>? <Cmd>call filcab#help#CTRL_W_Help()<cr>
tnoremap <unique> <C-w>? <Cmd>call filcab#help#CTRL_W_Help()<cr>
inoremap <unique> <C-x>? <Cmd>call filcab#help#CTRL_X_Help()<cr>
" FIXME: Add one for netrw
" FIXME: Maybe fugitive buffers?

" From http://vim.wikia.com/wiki/Auto_highlight_current_word_when_idle
nnoremap <unique> z/ :if filcab#AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>

noremap <unique> <localleader>? <Cmd>call filcab#help#map_Help('<localleader>')<cr>

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

let g:loaded_mappings = 1
