autocmd BufRead,BufNewFile *.ll set filetype=llvm
autocmd BufRead,BufNewFile *.td set filetype=tablegen

" LLVM source tree special cases
autocmd BufRead,BufNewFile lit.*cfg set filetype=python
autocmd BufNewFile,BufRead **/*llvm*/**/*.h set ft=cpp.doxygen
" clang uses these for defining node types, so it will be cpp for now
" (along with .def)
autocmd BufNewFile,BufRead **/*llvm*/**/*.inc,**/*llvm*/**/**.def set ft=cpp

" Javascript proxy stuff. Use "default" names only
autocmd BufRead,BufNewFile proxy.pac,wpad.dat set filetype=javascript

" SWIG to generate cross-language bindings
autocmd BufRead,BufNewFile *.swig   set filetype=swig

" Not technically filetype, but import vim-afterimage if we're editing one of
" the supported files
autocmd BufReadPre,FileReadPre    *.png,*.gif,*.bmp,*.ico,*.pdf,*.doc,*.plist  packadd vim-afterimage
