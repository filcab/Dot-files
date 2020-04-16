" Programming related setup

" clang-format changed lines on save
let g:clang_format_on_save = 1  " Will query buffer-local variable of the same name first
" Have an escape hatch for fugitive buffers (usually a git diff), for now
let g:clang_format_fugitive = 1

" LSP setup is not ready yet
"let g:disable_youcompleteme = 0
"let g:disable_lsp = 0

" Set this wether or not we're disabling ycm, since we might not find the LSP
" programs
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_extra_conf.py'
let g:ycm_rust_src_path = $RUST_SRC_PATH
" Initialize so we can add to it later per filetype
let g:ycm_filetype_blacklist = {}

" completion (CTRL+N) options
if !exists( "g:loaded_youcompleteme" )
  " filcab:
  " If we set this variable and then reload vimrc, when YouCompleteMe is
  " enabled, we end up with some weird behaviour where words which YCM tries
  " to complete will get deleted whilst being written.
  set completeopt+=longest
endif

let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
"let g:lsp_log_verbose = 0
"let g:lsp_log_file = expand('~/vim-lsp.log')
