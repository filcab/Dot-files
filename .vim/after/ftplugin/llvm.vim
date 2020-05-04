" Vim filetype plugin file
" Language: LLVM Assembly
" Maintainer: The LLVM team, http://llvm.org/

if exists("b:did_filcab_after_llvm_ftplugin")
  finish
endif

setlocal softtabstop=2 shiftwidth=2
setlocal expandtab
setlocal iskeyword+=@ iskeyword+=%
"setlocal comments+=:;
setlocal comments=s0:\ -,m0:;,e0:;;,:;

let b:undo_ftplugin .= '|setlocal softtabstop< shiftwidth< expandtab< iskeyword< comments<'
let b:did_filcab_after_llvm_ftplugin = 1
