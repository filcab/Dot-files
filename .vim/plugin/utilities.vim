if exists('g:loaded_utilities')
  finish
endif

" From http://vim.wikia.com/wiki/Auto_highlight_current_word_when_idle
" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=4000
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=500
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction

""""""""""""" C family mappings
function FilCabRustToolMappings(...)
  " Bail out if the mappings have already been setup on this buffer
  if exists('b:filcab_setup_rust_tool_mappings')
    return
  endif

  nnoremap <buffer><unique> <LocalLeader><Tab> :RustFmt<cr>
  vnoremap <buffer><unique> <LocalLeader><Tab> :RustFmtRange<cr>
  inoremap <buffer><unique> <C-Tab><Tab> <C-o>:RustFmtRange<cr><cr>

  let b:filcab_setup_rust_tool_mappings=1
endfunction

"YouCompleteMe mappings
function! s:ShowYCMNumberOfWarningsAndErrors()
  echo 'YCM reports: Errors: ' . youcompleteme#GetErrorCount() . ' Warnings: ' . youcompleteme#GetWarningCount()
endfunction

" TODO: Refactor this to just call a dictionary's values. Then set them to
" whatever. The keybindings should just get a function from there and call it.
function FilCabYCMAndLSPMappings()
  " bail out if the mappings have already been setup on this buffer
  if exists('b:filcab_setup_ycm_and_lsp_mappings')
    return
  endif

  " This should be independent of language, but let's start with the C family only
  " Later maybe have a function/macro/whatever to setup for the different file types
  if !g:disable_youcompleteme
    let g:ycm_add_preview_to_completeopt = 1
    " General (refresh)
    nnoremap <buffer><unique> <LocalLeader><F5> :YcmForceCompileAndDiagnostics<cr>

    """""""" GoTo commands
    " First keybinding has a delay to serve as a default for "go" commands
    nnoremap <buffer><unique> <LocalLeader>g :YcmCompleter GoTo<cr>
    nnoremap <buffer><unique> <LocalLeader>gg :YcmCompleter GoTo<cr>

    " Default (lowercase) is to go to the definition, else declaration
    nnoremap <buffer><unique> <LocalLeader>gd :YcmCompleter GoToDefinition<cr>
    nnoremap <buffer><unique> <LocalLeader>gD :YcmCompleter GoToDeclaration<cr>

    " Bind to both lower and uppercase
    " Not available in C/C++: (available in Python and JS, though)
    nnoremap <buffer><unique> <LocalLeader>gr :YcmCompleter GoToReferences<cr>
    nnoremap <buffer><unique> <LocalLeader>gR :YcmCompleter GoToReferences<cr>

    " unsure this is needed:
    nnoremap <buffer><unique> <LocalLeader>gdd :YcmCompleter GoToDefinitionElseDeclaration<cr>

    """" C/C++ mode only, I guess
    " Bind to both lower and uppercase
    " FILCAB: Maybe override gf *if* we're sure there's a compilation database?
    " FILCAB: check https://github.com/martong/vim-compiledb-path
    nnoremap <buffer><unique> <LocalLeader>gi :YcmCompleter GoToInclude<cr>

    """""""" Get commands (information)
    " Default (lowercase) is to use the imprecise (faster) function
    nnoremap <buffer><unique> <LocalLeader>t :YcmCompleter GetTypeImprecise<cr>
    nnoremap <buffer><unique> <LocalLeader>T :YcmCompleter GetType<cr>

    " Bind to both lower and uppercase
    nnoremap <buffer><unique> <LocalLeader>p :YcmCompleter GetParent<cr>
    nnoremap <buffer><unique> <LocalLeader>P :YcmCompleter GetParent<cr>

    " Bind to both lower and uppercase
    " 'd' is taken for definition/declaration
    nnoremap <buffer><unique> <LocalLeader>o :YcmCompleter GetDocImprecise<cr>
    nnoremap <buffer><unique> <LocalLeader>O :YcmCompleter GetDoc<cr>

    """""""" Refactoring
    nnoremap <buffer><unique> <LocalLeader>f :YcmCompleter FixIt<cr>

    """""""" Miscellaneous
    nnoremap <buffer><unique> <LocalLeader>w :call <SID>ShowYCMNumberOfWarningsAndErrors()<cr>
    nnoremap <buffer><unique> <LocalLeader>W :call <SID>ShowYCMNumberOfWarningsAndErrors()<cr>
  else
    " General (refresh)
    nnoremap <buffer><unique> <LocalLeader><F5> :LspDocumentDiagnostics<cr>

    """""""" GoTo commands
    " Default (lowercase) is to use the imprecise (faster) function
    nnoremap <buffer><unique> <LocalLeader>gg :LspDefinition<cr>
    nnoremap <buffer><unique> <LocalLeader>gG :LspDefinition<cr>
    nnoremap <buffer><unique> <LocalLeader>GG :LspDefinition<cr>

    " Default (lowercase) is to go to the definition, else declaration
    nnoremap <buffer><unique> <LocalLeader>gd :LspDefinition<cr>
    nnoremap <buffer><unique> <LocalLeader>gD :LspDefinition<cr>

    " Bind to both lower and uppercase
    " Not available in C/C++: (available in Python and JS, though)
    nnoremap <buffer><unique> <LocalLeader>gr :YcmCompleter GoToReferences<cr>
    nnoremap <buffer><unique> <LocalLeader>gR :YcmCompleter GoToReferences<cr>

    " unsure this is needed:
    nnoremap <buffer><unique> <LocalLeader>gdd :YcmCompleter GoToDefinitionElseDeclaration<cr>

    """" C/C++ mode only, I guess
    " Bind to both lower and uppercase
    " FILCAB: Maybe override gf *if* we're sure there's a compilation database?
    " FILCAB: check https://github.com/martong/vim-compiledb-path
    nnoremap <buffer><unique> <LocalLeader>gi :YcmCompleter GoToInclude<cr>

    """""""" Get commands (information)
    " Default (lowercase) is to use the imprecise (faster) function
    nnoremap <buffer><unique> <LocalLeader>t :YcmCompleter GetTypeImprecise<cr>
    nnoremap <buffer><unique> <LocalLeader>T :YcmCompleter GetType<cr>

    " Bind to both lower and uppercase
    nnoremap <buffer><unique> <LocalLeader>p :YcmCompleter GetParent<cr>
    nnoremap <buffer><unique> <LocalLeader>P :YcmCompleter GetParent<cr>

    " Bind to both lower and uppercase
    " 'd' is taken for definition/declaration
    nnoremap <buffer><unique> <LocalLeader>o :YcmCompleter GetDocImprecise<cr>
    nnoremap <buffer><unique> <LocalLeader>O :YcmCompleter GetDoc<cr>

    """""""" Refactoring
    nnoremap <buffer><unique> <LocalLeader>f :YcmCompleter FixIt<cr>

    """""""" Miscellaneous
    nnoremap <buffer><unique> <LocalLeader>w :call <SID>ShowYCMNumberOfWarningsAndErrors()<cr>
    nnoremap <buffer><unique> <LocalLeader>W :call <SID>ShowYCMNumberOfWarningsAndErrors()<cr>
  endif
  let b:filcab_setup_ycm_and_lsp_mappings=1
endfunction

let g:loaded_utilities = 1
