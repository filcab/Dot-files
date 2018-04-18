if exists('g:loaded_mappings')
  finish
endif

" Map <LocalLeader> to , by default (was \, same as <Leader>)
let maplocalleader=','

" Help for some bindings:
noremap <unique> <LocalLeader>? :map <LocalLeader><cr>
noremap <unique> <Leader>? :map <Leader><cr>
nnoremap <unique> [? :map [<cr>
nnoremap <unique> ]? :map ]<cr>
nnoremap <unique> <C-w>? :call CTRL_W_Help()<cr>
inoremap <unique> <C-w>? <C-o>:call CTRL_W_Help()<cr><cr>

" From http://vim.wikia.com/wiki/Auto_highlight_current_word_when_idle
nnoremap <unique> z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>

""""""""""""" C family mappings
autocmd Filetype c,objc,cpp,objcpp nnoremap <buffer><silent><unique> <F5> :call ClangCheck()<CR><CR>

" clang-format integration
autocmd Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader><Tab> :pyf ~/.vim/clang-format.py<cr>
autocmd Filetype c,objc,cpp,objcpp vnoremap <buffer><unique> <LocalLeader><Tab> :pyf ~/.vim/clang-format.py<cr>
autocmd Filetype c,objc,cpp,objcpp inoremap <buffer><unique> <C-S-Tab> <C-o>:pyf ~/.vim/clang-format.py<cr><cr>

"YouCompleteMe mappings
if !g:disable_youcompleteme
  let g:ycm_add_preview_to_completeopt = 1
  " This should be independent of language, but let's start with the C family only
  " Later maybe have a function/macro/whatever to setup for the different file types
  augroup cpp
    " General (refresh)
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader><F5> :YcmForceCompileAndDiagnostics<cr>

    """""""" GoTo commands
    " Default (lowercase) is to use the imprecise (faster) function
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>g :YcmCompleter GoToImprecise<cr>
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>G :YcmCompleter GoTo<cr>

    " Default (lowercase) is to go to the definition, else declaration
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>d :YcmCompleter GoToDefinition<cr>
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>D :YcmCompleter GoToDeclaration<cr>

    " Bind to both lower and uppercase
    " Not available in C/C++: (available in Python and JS, though)
    "au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>r :YcmCompleter GoToReferences<cr>
    "au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>R :YcmCompleter GoToReferences<cr>

    " unsure this is needed:
    "au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>/ :YcmCompleter GoToDefinitionElseDeclaration<cr>

    """" C/C++ mode only, I guess
    " Bind to both lower and uppercase
    " FILCAB: Maybe override gf *if* we're sure there's a compilation database?
    " FILCAB: check https://github.com/martong/vim-compiledb-path
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>i :YcmCompleter GoToInclude<cr>
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>I :YcmCompleter GoToInclude<cr>

    """""""" Get commands (information)
    " Default (lowercase) is to use the imprecise (faster) function
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>t :YcmCompleter GetTypeImprecise<cr>
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>T :YcmCompleter GetType<cr>

    " Bind to both lower and uppercase
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>p :YcmCompleter GetParent<cr>
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>P :YcmCompleter GetParent<cr>

    " Bind to both lower and uppercase
    " 'd' is taken for definition/declaration
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>o :YcmCompleter GetDocImprecise<cr>
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>O :YcmCompleter GetDoc<cr>

    """""""" Refactoring
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>f :YcmCompleter FixIt<cr>

    """""""" Miscellaneous
    function! ShowYCMNumberOfWarningsAndErrors()
      echo 'YCM reports: Errors: ' . youcompleteme#GetErrorCount() . ' Warnings: ' . youcompleteme#GetWarningCount()
    endfunction
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>w :call ShowYCMNumberOfWarningsAndErrors()<cr>
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>W :call ShowYCMNumberOfWarningsAndErrors()<cr>
  augroup END
else
  " Really need to refactor this
  augroup cpp
    " General (refresh)
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader><F5> :LspDocumentDiagnostics<cr>

    """""""" GoTo commands
    " Default (lowercase) is to use the imprecise (faster) function
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>g :LspDefinition<cr>
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>G :LspDefinition<cr>

    " Default (lowercase) is to go to the definition, else declaration
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>d :LspDefinition<cr>
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>D :LspDefinition<cr>

    " Bind to both lower and uppercase
    " Not available in C/C++: (available in Python and JS, though)
    "au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>r :YcmCompleter GoToReferences<cr>
    "au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>R :YcmCompleter GoToReferences<cr>

    " unsure this is needed:
    "au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>/ :YcmCompleter GoToDefinitionElseDeclaration<cr>

    """" C/C++ mode only, I guess
    " Bind to both lower and uppercase
    " FILCAB: Maybe override gf *if* we're sure there's a compilation database?
    " FILCAB: check https://github.com/martong/vim-compiledb-path
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>i :YcmCompleter GoToInclude<cr>
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>I :YcmCompleter GoToInclude<cr>

    """""""" Get commands (information)
    " Default (lowercase) is to use the imprecise (faster) function
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>t :YcmCompleter GetTypeImprecise<cr>
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>T :YcmCompleter GetType<cr>

    " Bind to both lower and uppercase
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>p :YcmCompleter GetParent<cr>
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>P :YcmCompleter GetParent<cr>

    " Bind to both lower and uppercase
    " 'd' is taken for definition/declaration
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>o :YcmCompleter GetDocImprecise<cr>
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>O :YcmCompleter GetDoc<cr>

    """""""" Refactoring
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>f :YcmCompleter FixIt<cr>

    """""""" Miscellaneous
    function! ShowYCMNumberOfWarningsAndErrors()
      echo 'YCM reports: Errors: ' . youcompleteme#GetErrorCount() . ' Warnings: ' . youcompleteme#GetWarningCount()
    endfunction
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>w :call ShowYCMNumberOfWarningsAndErrors()<cr>
    au Filetype c,objc,cpp,objcpp nnoremap <buffer><unique> <LocalLeader>W :call ShowYCMNumberOfWarningsAndErrors()<cr>
  augroup END
endif


let g:loaded_mappings = 1
