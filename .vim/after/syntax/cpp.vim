" These settings need to come after the syntax plugin runs so they don't get
" overridden.

" FIXME: Double-check if we still want this
" Adjusted (to make it work... and add constexpr, volatile) from vim-tips page about C++
" Adjusted to add consteval co_await co_return co_yield
syntax match cppFuncDefExtra "::\~\?\zs\h\w*\ze([^)]*)\s*\(const\|consteval\|constexpr\|co_await\|co_return\|co_yield\|volatile\)* *{\?$"
hi def link cppFuncDefExtra cSpecial
