"   \ 'vim': ['vim'],
" the rst.vim syntax file will source these syntax files and if vim.vim is in
" there, it will error saying we've specified syntax sync linecont patterns
" multiple times
" FIXME: Maybe vim will fix this eventually?
let g:rst_syntax_code_list = {
    \ 'java': ['java'],
    \ 'cpp': ['cpp', 'c++'],
    \ 'lisp': ['lisp'],
    \ 'php': ['php'],
    \ 'python': ['python'],
    \ 'perl': ['perl'],
    \ 'sh': ['sh'],
    \ }
