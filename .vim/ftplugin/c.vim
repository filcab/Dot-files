" This file will also be sourced by the cpp ftplugin
if exists("b:did_filcab_c_ftplugin")
  finish
endif
let b:did_filcab_c_ftplugin = 1

" Setup clang-format on save functionality only in C/C++ files
autocmd BufWritePre <buffer> call filcab#ClangFormat()
