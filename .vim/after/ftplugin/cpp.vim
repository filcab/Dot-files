if exists("b:did_filcab_after_cpp_ftplugin")
  finish
endif

" Needs to be after/ftplugin as our personal ftplugin gets loaded before the
" system's, which can override this setting.
setlocal commentstring=//\ %s
let b:undo_ftplugin .= "|setlocal commentstring<"

let b:did_filcab_after_cpp_ftplugin = 1
