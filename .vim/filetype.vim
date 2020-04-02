autocmd BufRead,BufNewFile *.ll set filetype=llvm
autocmd BufRead,BufNewFile *.td set filetype=tablegen

" LLVM source tree special cases
autocmd BufRead,BufNewFile lit.*cfg set filetype=python

" Javascript proxy stuff. Use "default" names only
autocmd BufRead,BufNewFile proxy.pac,wpad.dat set filetype=javascript
