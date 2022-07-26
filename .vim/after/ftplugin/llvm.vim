" Vim filetype plugin file
" Language: LLVM Assembly
" Maintainer: The LLVM team, http://llvm.org/

if exists("b:did_filcab_after_llvm_ftplugin")
  finish
endif

setlocal iskeyword+=@ iskeyword+=%
"setlocal comments+=:;
setlocal comments=s0:\ -,m0:;,e0:;;,:;

let s:undo_ftplugin = 'setlocal softtabstop< shiftwidth< expandtab< iskeyword< comments<'
if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'.s:undo_ftplugin
else
  let b:undo_ftplugin = s:undo_ftplugin
endif
let b:did_filcab_after_llvm_ftplugin = 1
