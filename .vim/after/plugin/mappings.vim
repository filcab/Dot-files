if exists('g:loaded_mappings')
  finish
endif

" All mappings should be unique so we know we're not clashing with built-in or
" other plugin mappings. This requires a workaround for autocmd, which is to
" go through a function to setup the mappings, and bailing out if they're
" already setup.
" Eventually this might be problematic if we keep switching filetype on the
" same buffer. Let's only fix that if it becomes a problem.

" Map <LocalLeader> to , by default (was \, same as <Leader>)
let maplocalleader=','


" Help for some bindings:
noremap <unique> <LocalLeader>? :map <LocalLeader><cr>
noremap <unique> <Leader>? :map <Leader><cr>
nnoremap <unique> [? :map [<cr>
nnoremap <unique> ]? :map ]<cr>
nnoremap <unique> <C-w>? :call CTRL_W_Help()<cr>
inoremap <unique> <C-w>? <C-o>:call CTRL_W_Help()<cr>
inoremap <unique> <C-x>? <C-o>:call CTRL_X_Help()<cr>
" FIXME: Add one for netrw
" FIXME: Maybe fugitive buffers?

" From http://vim.wikia.com/wiki/Auto_highlight_current_word_when_idle
nnoremap <unique> z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>

""""""""""""" C family mappings
" Pass v:true if you just want clang-format mappings
function s:ClangToolMappings(...)
  " Bail out if the mappings have already been setup on this buffer
  if exists('b:filcab_setup_clang_tool_mappings')
    return
  endif

  " clang-format integration
  if has('python')
    nnoremap <buffer><unique> <LocalLeader><Tab> :pyf ~/.vim/clang-format.py<cr>
    vnoremap <buffer><unique> <LocalLeader><Tab> :pyf ~/.vim/clang-format.py<cr>
    inoremap <buffer><unique> <C-Tab><Tab> <C-o>:pyf ~/.vim/clang-format.py<cr><cr>
  elseif has('python3')
    nnoremap <buffer><unique> <LocalLeader><Tab> :py3f ~/.vim/clang-format.py<cr>
    vnoremap <buffer><unique> <LocalLeader><Tab> :py3f ~/.vim/clang-format.py<cr>
    inoremap <buffer><unique> <C-Tab><Tab> <C-o>:py3f ~/.vim/clang-format.py<cr><cr>
  else
    echom 'Python/Python3 not available, skipping clang-format mappings'
  endif

  let clang_format_only = get(a:, 0, v:false)
  if clang_format_only
    return
  endif

  nnoremap <buffer><silent><unique> <F5> :call ClangCheck()<CR><CR>

  let b:filcab_setup_clang_tool_mappings=1
endfunction
augroup filcab_clang_tools
  autocmd!
  autocmd Filetype c,objc,cpp,objcpp call s:ClangToolMappings()
  " Just do the clang-format mapping
  autocmd Filetype javascript call s:ClangToolMappings(v:true)
augroup END

function s:RustToolMappings(...)
  " Bail out if the mappings have already been setup on this buffer
  if exists('b:filcab_setup_rust_tool_mappings')
    return
  endif

  nnoremap <buffer><unique> <LocalLeader><Tab> :RustFmt<cr>
  vnoremap <buffer><unique> <LocalLeader><Tab> :RustFmtRange<cr>
  inoremap <buffer><unique> <C-Tab><Tab> <C-o>:RustFmtRange<cr><cr>

  let b:filcab_setup_rust_tool_mappings=1
endfunction
augroup filcab_rust
  autocmd Filetype rust call s:RustToolMappings()
augroup END

"YouCompleteMe mappings
function! s:ShowYCMNumberOfWarningsAndErrors()
  echo 'YCM reports: Errors: ' . youcompleteme#GetErrorCount() . ' Warnings: ' . youcompleteme#GetWarningCount()
endfunction

" TODO: Refactor this to just call a dictionary's values. Then set them to
" whatever. The keybindings should just get a function from there and call it.
if !g:disable_youcompleteme
  let g:ycm_add_preview_to_completeopt = 1
  " This should be independent of language, but let's start with the C family only
  " Later maybe have a function/macro/whatever to setup for the different file types
  function s:YCMAndLSPMappings()
    " bail out if the mappings have already been setup on this buffer
    if exists('b:filcab_setup_ycm_and_lsp_mappings')
      return
    endif
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
    let b:filcab_setup_ycm_and_lsp_mappings=1
  endfunction

else
  " Really need to refactor this
  function s:YCMAndLSPMappings()
    " bail out if the mappings have already been setup on this buffer
    if exists('b:filcab_setup_ycm_and_lsp_mappings')
      return
    endif

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
    let b:filcab_setup_ycm_and_lsp_mappings=1
  endfunction
endif

augroup filcab_mappings
  autocmd!
  " Filetypes supported by my usual YCM installs:
  " C family, Python, Rust, JS
  autocmd Filetype c,objc,cpp,objcpp call s:YCMAndLSPMappings()
  autocmd Filetype python,rust,javascript call s:YCMAndLSPMappings()
augroup END

let g:loaded_mappings = 1
