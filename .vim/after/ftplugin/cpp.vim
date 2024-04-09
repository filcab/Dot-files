if exists("b:did_filcab_after_cpp_ftplugin")
  finish
endif

" Needs to be after/ftplugin as our personal ftplugin gets loaded before the
" system's, which can override this setting.
let b:undo_ftplugin .= "|setlocal commentstring<|unlet b:did_filcab_after_cpp_ftplugin"

let b:did_filcab_after_cpp_ftplugin = 1
