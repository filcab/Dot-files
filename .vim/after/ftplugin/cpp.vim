if exists("b:did_filcab_c_ftplugin")
  finish
endif
" The C ftplugin will set b:did_filcab_c_ftplugin

" FIXME: Double-check if we still want this
syntax match cppFuncDef "::\~\?\zs\h\w*\ze([^)]*\()\s*\(const\)\?\)\?$"
hi def link cppFuncDef Special

setlocal commentstring=//\ %s
