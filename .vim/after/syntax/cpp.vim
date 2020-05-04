" These settings need to come after the syntax plugin runs so they don't get
" overridden.

" FIXME: Double-check if we still want this
" Adjusted (to make it work... and add constexpr, volatile) from vim-tips page about C++
syntax match cppFuncDefExtra "::\~\?\zs\h\w*\ze([^)]*)\s*\(const\|constexpr\|volatile\)* *{\?$"
hi def link cppFuncDefExtra cSpecial
