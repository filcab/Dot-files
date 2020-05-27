if exists('g:loaded_mappings')
  finish
endif

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
noremap <unique><expr> <Leader>? ':<C-u>WhichKey "'.get(g:, 'mapleader', '\\').'"<cr>'
noremap <unique><expr> <LocalLeader>? ':<C-u>WhichKey "'.g:maplocalleader.'"<cr>'
nnoremap <unique> [? :<C-u>WhichKey '['<cr>
nnoremap <unique> ]? :<C-u>WhichKey ']'<cr>
tnoremap <unique> [? :<C-u>WhichKey '['<cr>
tnoremap <unique> ]? :<C-u>WhichKey ']'<cr>
nnoremap <unique> <C-w>? :call filcab#CTRL_W_Help()<cr>
tnoremap <unique> <C-w>? :call filcab#CTRL_W_Help()<cr>
inoremap <unique> <C-w>? <C-o>:call filcab#CTRL_W_Help()<cr>
inoremap <unique> <C-x>? <C-o>:call filcab#CTRL_X_Help()<cr>
" FIXME: Add one for netrw
" FIXME: Maybe fugitive buffers?

" From http://vim.wikia.com/wiki/Auto_highlight_current_word_when_idle
nnoremap <unique> z/ :if filcab#AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>

let g:loaded_mappings = 1
