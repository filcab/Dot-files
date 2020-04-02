if exists('g:loaded_utilities')
  finish
endif

" Find programs given search paths
let s:exe_suffix = has('win32') ? '.exe' : ''
function! FindProgram(prog_name, dirs)
  " Search $PATH first (might want to do this at the end, occasionally)
  if executable(a:prog_name) == 1
    return a:prog_name
  endif

  for dir in a:dirs
    let l:maybe_prog = expand(dir . '/' . a:prog_name . s:exe_suffix)
    if executable(l:maybe_prog) == 1
      return l:maybe_prog
    endif
  endfor

  " Signal we didn't find anything, which might trigger a search for a
  " different program name
  return ''
endfunction

" clang-format changed lines on save
let g:clang_format_on_save = 1  " Will query buffer-local variable of the same name first
" Have an escape hatch for fugitive buffers (usually a git diff), for now
let g:clang_format_fugitive = 1
function! s:FilCabClangFormatOnSave()
  if get(b:, 'clang_format_on_save', g:clang_format_on_save)
    if !has('python') && !has('python3')
      echo 'Could not clang-format. Python not available.'
      return
    endif

    let path = expand('%')
    if !filereadable(path)
      echom 'Not running clang-format: File is not readable: ' . path
      return
    elseif path =~# '^fugitive://' && !g:clang_format_fugitive
      echo 'Skipping clang-format: File is a fugitive:// file (use g:clang_format_fugitive to change this)'
      return
    else
      echom 'Running clang-format!'
      let l:formatdiff = 1
      if has('python')
        pyf ~/.vim/clang-format.py
      elseif has('python3')
        py3f ~/.vim/clang-format.py
      endif
    endif
  endif
endfunction

" clang-check functions
function! ClangCheckImpl(cmd)
  " filcab: Original wrote all modified buffers (wall), but let's just write
  " the current one.
  if &autowrite | w | endif
  echo "Running " . a:cmd . " ..."
  let l:output = system(a:cmd)
  cexpr l:output
  cwindow
  let w:quickfix_title = a:cmd
  if v:shell_error != 0
    cc
  else
    redraw  " Force a redraw so we see the next message (hint from help :echo)
    echo 'clang-check found no problems'
  endif
  let s:clang_check_last_cmd = a:cmd
endfunction
function! ClangCheck()
  let l:filename = expand('%')
  if l:filename =~ '\.\(cpp\|cxx\|cc\|c\)$'
    call ClangCheckImpl(shellescape(g:clang_check_path) . " " . l:filename)
  elseif exists("s:clang_check_last_cmd")
    call ClangCheckImpl(s:clang_check_last_cmd)
  else
    echo "Can't detect file's compilation arguments and no previous clang-check invocation!"
  endif
endfunction

function! CTRL_W_Help()
  echo 'Default CTRL-W key bindings. Also work as C-w C-<whatever>'
  echo 'command		action in Normal mode'
  echo '----------------------------------------------------------'
  echo 'CTRL-W "	terminal window: paste register'
  echo 'CTRL-W +	increase current window height N lines'
  echo 'CTRL-W -	decrease current window height N lines'
  echo 'CTRL-W .	terminal window: type CTRL-W'
  echo 'CTRL-W :	same as |:|, edit a command line'
  echo 'CTRL-W <	decrease current window width N columns'
  echo 'CTRL-W =	make all windows the same height & width'
  echo 'CTRL-W >	increase current window width N columns'
  echo 'CTRL-W H	move current window to the far left'
  echo 'CTRL-W J	move current window to the very bottom'
  echo 'CTRL-W K	move current window to the very top'
  echo 'CTRL-W L	move current window to the far right'
  echo 'CTRL-W N	terminal window: go to Terminal Normal mode'
  echo 'CTRL-W P	go to preview window'
  echo 'CTRL-W R	rotate windows upwards N times'
  echo 'CTRL-W S	same as "CTRL-W s"'
  echo 'CTRL-W T	move current window to a new tab page'
  echo 'CTRL-W W	go to N previous window (wrap around)'
  echo 'CTRL-W ]	split window and jump to tag under cursor'
  echo 'CTRL-W ^	split current window and edit alternate file N'
  echo 'CTRL-W _	set current window height to N (default: very high)'
  echo 'CTRL-W b	go to bottom window'
  echo 'CTRL-W c	close current window (like |:close|)'
  echo 'CTRL-W d	split window and jump to definition under the cursor'
  echo 'CTRL-W f	split window and edit file name under the cursor'
  echo 'CTRL-W F	split window and edit file name under the cursor and jump to the line number following the file name.'
  echo 'CTRL-W g CTRL-]	split window and do |:tjump| to tag under cursor'
  echo 'CTRL-W g ]	split window and do |:tselect| for tag under cursor'
  echo 'CTRL-W g }	do a |:ptjump| to the tag under the cursor'
  echo 'CTRL-W g f	edit file name under the cursor in a new tab page'
  echo 'CTRL-W g F	edit file name under the cursor in a new tab page and jump to the line number following the file name.'
  echo 'CTRL-W h	go to Nth left window (stop at first window)'
  echo 'CTRL-W i	split window and jump to declaration of identifier under the cursor'
  echo 'CTRL-W j	go N windows down (stop at last window)'
  echo 'CTRL-W k	go N windows up (stop at first window)'
  echo 'CTRL-W l	go to Nth right window (stop at last window)'
  echo 'CTRL-W n	open new window, N lines high'
  echo 'CTRL-W o	close all but current window (like |:only|)'
  echo 'CTRL-W p	go to previous (last accessed) window'
  echo 'CTRL-W q	quit current window (like |:quit|)'
  echo 'CTRL-W r	rotate windows downwards N times'
  echo 'CTRL-W s	split current window in two parts, new window N lines high'
  echo 'CTRL-W t	go to top window'
  echo 'CTRL-W v	split current window vertically, new window N columns wide'
  echo 'CTRL-W w	go to N next window (wrap around)'
  echo 'CTRL-W x	exchange current window with window N (default: next window)'
  echo 'CTRL-W z	close preview window set window width to N columns'
  echo 'CTRL-W }	show tag under cursor in preview window'
  echo ' '
  echo 'CTRL-W ?	filcab: Show help'
endfunction

function! CTRL_X_Help()
  echo 'Default CTRL-X key bindings for completion.'
  echo 'command		completion action'
  echo '----------------------------------------------------------'
  echo "CTRL-X CTRL-E	Cancel and go back to before autocomplete"
  echo "CTRL-X CTRL-Y	Stop completion and accept the current selection"
  echo " "
  echo "CTRL-X CTRL-L	Whole lines"
  echo "CTRL-X CTRL-N	keywords in the current file"
  echo "CTRL-X CTRL-K	keywords in 'dictionary'"
  echo "CTRL-X CTRL-T	keywords in 'thesaurus', thesaurus-style"
  echo "CTRL-X CTRL-I	keywords in the current and included files"
  echo "CTRL-X CTRL-]	tags"
  echo "CTRL-X CTRL-F	file names"
  echo "CTRL-X CTRL-D	definitions or macros"
  echo "CTRL-X CTRL-V	Vim command-line"
  echo "CTRL-X CTRL-U	User defined completion"
  echo "CTRL-X CTRL-O	omni completion"
  echo "CTRL-X s	Spelling suggestions"
  echo "CTRL-N/CTRL-P	cycle keywords in 'complete'"
  echo " "
  echo "CTRL-X ?	filcab: show help"
  echo " "
  echo "All these, except CTRL-N and CTRL-P, are done in CTRL-X mode.  This is a"
  echo "sub-mode of Insert and Replace modes.  You enter CTRL-X mode by typing CTRL-X"
  echo "and one of the CTRL-X commands.  You exit CTRL-X mode by typing a key that is"
  echo "not a valid CTRL-X mode command.  Valid keys are the CTRL-X command itself,"
  echo "CTRL-N (next), and CTRL-P (previous)."
endfunction

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
" Pass v:true if you just want clang-format mappings
function FilCabClangToolMappings(...)
  " Bail out if the mappings have already been setup on this buffer
  if exists('b:filcab_setup_clang_tool_mappings')
    return
  endif
  let b:filcab_setup_clang_tool_mappings=1

  " clang-format integration
  if has('python3')
    nnoremap <buffer><unique> <LocalLeader><Tab> :py3f ~/.vim/clang-format.py<cr>
    vnoremap <buffer><unique> <LocalLeader><Tab> :py3f ~/.vim/clang-format.py<cr>
    inoremap <buffer><unique> <C-Tab><Tab> <C-o>:py3f ~/.vim/clang-format.py<cr><cr>
  elseif has('python')
    nnoremap <buffer><unique> <LocalLeader><Tab> :pyf ~/.vim/clang-format.py<cr>
    vnoremap <buffer><unique> <LocalLeader><Tab> :pyf ~/.vim/clang-format.py<cr>
    inoremap <buffer><unique> <C-Tab><Tab> <C-o>:pyf ~/.vim/clang-format.py<cr><cr>
  else
    echom 'Python3/Python not available, skipping clang-format mappings'
  endif

  let clang_format_only = get(a:, 0, v:false)
  if clang_format_only
    return
  endif

  nnoremap <buffer><silent><unique> <F5> :call ClangCheck()<CR><CR>
endfunction

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
if !g:disable_youcompleteme
  let g:ycm_add_preview_to_completeopt = 1
  " This should be independent of language, but let's start with the C family only
  " Later maybe have a function/macro/whatever to setup for the different file types
  function FilCabYCMAndLSPMappings()
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
  function FilCabYCMAndLSPMappings()
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

let g:loaded_utilities = 1
