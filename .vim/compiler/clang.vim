" vim compiler file
" Compiler:		clang (Apple c compiler)
" Maintainer:   Vincent B. (twinside@free.fr)
" Last Change:  2010 sep 28
" Changed by Filipe C. afterwards

if exists("current_compiler")
  finish
endif
let current_compiler = "clang"

let s:cpo_save = &cpo
set cpo&vim

" With some ninja ignores/information added
CompilerSet errorformat+=%D%*\\a:\ Entering\ directory\ `%f'
CompilerSet errorformat+=%E%f\\(%l\\,%c\\)\ :\ \ %trror:\ %m,%-C%s,%-Z%p^
CompilerSet errorformat+=%W%f\\(%l\\,%c\\)\ :\ \ %tarning:\ %m,%-C%s,%-Z%p^
CompilerSet errorformat+=%I%f\\(%l\\,%c\\)\ :\ \ note:\ %m,%-C%s,%-Z%p^
CompilerSet errorformat+=%-I%.%#[%*[/0-9]]\ %m,%IFAILED:\ ,%Z
",%-C%m,%-Z%p^,%-C%p^,%-Z%p%s
"      \%f\\(%l\\,%c\\)\ :\ \ %t%s:\ %m,%C%m,%Z%p^,%C%p^,%Z%p%s,
"      \%f:%l:%c:\ %t%s:\ %m,
"      \%f\\(%l\\,%c\\)\ :\ \ %t%s:\ %m,
"      \%-G%[]%s



let &cpo = s:cpo_save
unlet s:cpo_save

"vim: ft=vim

