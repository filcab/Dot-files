if exists('g:loaded_mappings')
  finish
endif

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

" Have <LocalLeader>d! do a missing :Dispatch binding
noremap <unique> <LocalLeader>d! :Dispatch!<cr>
" Also have one which needs no shift
noremap <unique> <LocalLeader>d1 :Dispatch!<cr>
" Also add regular <cr> terminated, for consistency (no benefit vs d<cr>)
noremap <unique> <LocalLeader>d<cr> :Dispatch<cr>

" Help for some bindings:
noremap <unique> <LocalLeader>? :map <LocalLeader><cr>
noremap <unique> <Leader>? :map <Leader><cr>
nnoremap <unique> [? :map [<cr>
nnoremap <unique> ]? :map ]<cr>
nnoremap <unique> <C-w>? :call filcab#CTRL_W_Help()<cr>
inoremap <unique> <C-w>? <C-o>:call filcab#CTRL_W_Help()<cr>
inoremap <unique> <C-x>? <C-o>:call filcab#CTRL_X_Help()<cr>
" FIXME: Add one for netrw
" FIXME: Maybe fugitive buffers?

" From http://vim.wikia.com/wiki/Auto_highlight_current_word_when_idle
nnoremap <unique> z/ :if filcab#AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>

let g:loaded_mappings = 1
