" copied from after/syntax/cpp.vim, add some extra functions and types to the
" pythonBuiltin stuff
" These settings need to come after the syntax plugin runs so they don't get
" overridden.

" add some newer built-in functions that python-mode doesn't have

if get(g:, "pymode_syntax_builtin_types", 1)
  syn keyword pythonBuiltinTypeExtra memoryview
  hi def link pythonBuiltinTypeExtra Type
endif

if get(g:, "pymode_syntax_builtin_funcs", 1)
  syntax keyword pythonBuiltinFuncExtra aiter anext ascii breakpoint
  hi def link pythonBuiltinFuncExtra Function
endif
