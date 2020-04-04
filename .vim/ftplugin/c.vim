" This file will also be sourced by the cpp ftplugin
if exists("b:did_filcab_c_ftplugin")
  finish
endif
let b:did_filcab_c_ftplugin = 1

" Setup clang-format on save functionality only in C/C++ files
autocmd BufWritePre <buffer>
  \ if get(b:, 'clang_format_on_save', g:clang_format_on_save) |
  \   call filcab#c#ClangFormat() |
  \ endif

call filcab#c#ensure_loaded()

" Tell ycm about clangd (must be after we've ensured the autoload)
let g:ycm_clangd_binary_path = g:clangd_path
