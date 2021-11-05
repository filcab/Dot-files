if executable('python3')
  let s:pythonCmd = 'python3'
elseif executable('python')
  let s:pythonCmd = 'python'
else
  echoerr "Couldn't find python3 or python: UpdatePackages and RecompileYCM commands won't work"
endif

function! filcab#CTRL_W_Help()
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
  " show any extra maps
  map <C-w>
endfunction

function! filcab#CTRL_X_Help()
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
  echo "CTRL-X CTRL-O	omni completion (current: ".&omnifunc.")"
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
  " show any extra maps
  map <C-x>
endfunction

" From http://vim.wikia.com/wiki/Auto_highlight_current_word_when_idle
" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.
function! filcab#AutoHighlightToggle()
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

" Find programs given search paths
let s:exe_suffix = has('win32') ? '.exe' : ''
function! filcab#FindProgram(prog_name, dirs)
  " First search the passed in dirs
  for dir in a:dirs
    let l:maybe_prog = expand(dir . '/' . a:prog_name . s:exe_suffix)
    if executable(l:maybe_prog) == 1
      return l:maybe_prog
    endif
  endfor

  " Search $PATH (Maybe add an argument to *not* search in $PATH)
  if executable(a:prog_name) == 1
    return a:prog_name
  endif

  " Signal we didn't find anything, which might trigger a search for a
  " different program name
  return ''
endfunction

" Shared between C/C++ and Javascript
function! filcab#ClangFormat()
  " Doesn't do any verification. We've warned before.
  if !has('python') && !has('python3')
    echo 'Could not clang-format. Python not available.'
    return
  endif

  let path = expand('%')
  if !filereadable(path)
    echom 'Not running clang-format: File is not readable: ' . path
    return
  elseif path =~# '^fugitive://'
    echo 'Skipping clang-format: File is a fugitive:// file'
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
endfunction

" Shared amongst all YCM-using languages
function! filcab#packaddYCM()
  if get(g:, 'ycm_enable', 0)
    return
  endif
  " install different variants so we can control what library gets added
  if has("win32unix")
    packadd YouCompleteMe.win32unix
  elseif has("win32")
    packadd YouCompleteMe.win32
  else
    packadd YouCompleteMe
  endif
  " FIXME: submit a PR for YCM. It always complains about fugitive files in
  " big repos anyway.
  " Would be "nice" to be able to goto definition, but do we care?
  let g:ycm_filetype_blacklist = get(g:, 'ycm_filetype_blacklist', {})
  let g:ycm_filetype_blacklist['fugitive'] = 1
endfunction

function! filcab#ShowYCMNumberOfWarningsAndErrors()
  if !get(g:, 'disable_youcompleteme', v:false) && get(g:, 'loaded_youcompleteme', v:false)
    echo 'YCM reports: Errors: ' . youcompleteme#GetErrorCount()
        \ . ' Warnings: ' . youcompleteme#GetWarningCount()
  endif
endfunction

function! filcab#recompileYCM()
  " install different variants so we can control what library gets added
  if has("win32unix")
    let ycm_suffix = ".win32unix"
  elseif has("win32")
    let ycm_suffix = ".win32"
  else
    let ycm_suffix = ""
  endif

  let recompileScript = $MYVIMRUNTIME.'/pack/filcab/recompile-ycm'
  execute  ":terminal" "++shell" s:pythonCmd shellescape(recompileScript) "opt/YouCompleteMe".ycm_suffix
endfunction

function! filcab#updatePackages()
  let myPackDir = $MYVIMRUNTIME.'/pack/filcab'
  " FIXME: Maybe in the future try and use :py3f in vim, but still have it be
  " async...
  let script = shellescape(myPackDir."/get-files")
  let sourcesFile = shellescape(myPackDir."/sources")
  " use shell escapes and the ++shell argument as otherwise we'll get split on
  " spaces. I couldn't find a proper way to quote the arguments whilst still
  " not using shell (quotes would end up getting included in the arguments
  " themselves)

  if has("win32unix")
    let ycm_rename = "YouCompleteMe=YouCompleteMe.win32unix"
  elseif has("win32")
    let ycm_rename = "YouCompleteMe=YouCompleteMe.win32"
  else
    let ycm_rename = "YouCompleteMe=YouCompleteMe"
  endif

  execute ":terminal" "++open" "++shell" s:pythonCmd script "-o" shellescape(myPackDir) "--rename" ycm_rename sourcesFile
endfunction

" Function to run helptags on all the opt packages. Regular packages are
" already in |rtp|, so will have their helptags done with :helptags ALL
function! filcab#packOptHelpTags() abort
  for d in split(&packpath, ',')
    " skip any global plugins
    if stridx(d, $VIMRUNTIME) == 0
      continue
    endif

    " pack/$any/{opt,start}/$name/doc
    let dir = d.'/pack/*/*/*/doc'
    for doc in glob(dir, v:true, v:true)
      echom doc
      exe 'helptags '.fnameescape(doc)
    endfor
  endfor
endfunction

" Move the cursor to a terminal window if we have one open
function! filcab#gotoTermWindow() abort
  let term_bufs = term_list()
  for win in range(1, winnr('$'))
    if index(term_bufs, win->winbufnr()) >=0
      echom 'going to win:' win
      call win_gotoid(win_getid(win))
    endif
  endfor
endfunction
