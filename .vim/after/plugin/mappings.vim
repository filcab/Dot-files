if exists('g:loaded_mappings')
  finish
endif

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
nnoremap <unique> <C-w>? :call CTRL_W_Help()<cr>
inoremap <unique> <C-w>? <C-o>:call CTRL_W_Help()<cr>
inoremap <unique> <C-x>? <C-o>:call CTRL_X_Help()<cr>
" FIXME: Add one for netrw
" FIXME: Maybe fugitive buffers?

" From http://vim.wikia.com/wiki/Auto_highlight_current_word_when_idle
nnoremap <unique> z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>

" FIXME: These mappings should be set in ftplugins, probably using functions
" defined in utilities.vim or similar
augroup filcab_clang_tools
  autocmd!
  autocmd Filetype c,objc,cpp,objcpp call FilCabClangToolMappings()
  " Just do the clang-format mapping
  autocmd Filetype javascript call FilCabClangToolMappings(v:true)
augroup END

augroup filcab_rust
  autocmd Filetype rust call FilCabRustToolMappings()
augroup END

augroup filcab_mappings
  autocmd!
  " Filetypes supported by my usual YCM installs:
  " C family, Python, Rust, JS
  autocmd Filetype c,objc,cpp,objcpp call FilCabYCMAndLSPMappings()
  autocmd BufWritePre *.h,*.c,*.cc,*.cpp call FilcabClangFormatOnSave()
  autocmd Filetype python,rust,javascript call FilCabYCMAndLSPMappings()
augroup END

let g:loaded_mappings = 1
