" Vim filetype plugin file
" Language: LLVM TableGen
" Maintainer: The LLVM team, http://llvm.org/

if exists("b:did_ftplugin")
  finish
endif

setlocal matchpairs+=<:>
setlocal softtabstop=2 shiftwidth=2
setlocal expandtab

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '') . '|setlocal matchpairs< softtabstop< shiftwidth< expandtab<'
let b:did_ftplugin = 1
