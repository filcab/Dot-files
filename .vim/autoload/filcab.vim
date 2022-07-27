function! filcab#CTRL_W_Help()
  let lines = [
    \ 'command		action in Normal mode',
    \ '----------------------------------------------------------',
    \ 'CTRL-W "	terminal window: paste register',
    \ 'CTRL-W +	increase current window height N lines',
    \ 'CTRL-W -	decrease current window height N lines',
    \ 'CTRL-W .	terminal window: type CTRL-W',
    \ 'CTRL-W :	same as |:|, edit a command line',
    \ 'CTRL-W <	decrease current window width N columns',
    \ 'CTRL-W =	make all windows the same height & width',
    \ 'CTRL-W >	increase current window width N columns',
    \ 'CTRL-W H	move current window to the far left',
    \ 'CTRL-W J	move current window to the very bottom',
    \ 'CTRL-W K	move current window to the very top',
    \ 'CTRL-W L	move current window to the far right',
    \ 'CTRL-W N	terminal window: go to Terminal Normal mode',
    \ 'CTRL-W P	go to preview window',
    \ 'CTRL-W R	rotate windows upwards N times',
    \ 'CTRL-W S	same as "CTRL-W s"',
    \ 'CTRL-W T	move current window to a new tab page',
    \ 'CTRL-W W	go to N previous window (wrap around)',
    \ 'CTRL-W ]	split window and jump to tag under cursor',
    \ 'CTRL-W ^	split current window and edit alternate file N',
    \ 'CTRL-W _	set current window height to N (default: very high)',
    \ 'CTRL-W b	go to bottom window',
    \ 'CTRL-W c	close current window (like |:close|)',
    \ 'CTRL-W d	split window and jump to definition under the cursor',
    \ 'CTRL-W f	split window and edit file name under the cursor',
    \ 'CTRL-W F	split window and edit file name under the cursor and jump to the line number following the file name.',
    \ 'CTRL-W g CTRL-]	split window and do |:tjump| to tag under cursor',
    \ 'CTRL-W g ]	split window and do |:tselect| for tag under cursor',
    \ 'CTRL-W g }	do a |:ptjump| to the tag under the cursor',
    \ 'CTRL-W g f	edit file name under the cursor in a new tab page',
    \ 'CTRL-W g F	edit file name under the cursor in a new tab page and jump to the line number following the file name.',
    \ 'CTRL-W h	go to Nth left window (stop at first window)',
    \ 'CTRL-W i	split window and jump to declaration of identifier under the cursor',
    \ 'CTRL-W j	go N windows down (stop at last window)',
    \ 'CTRL-W k	go N windows up (stop at first window)',
    \ 'CTRL-W l	go to Nth right window (stop at last window)',
    \ 'CTRL-W n	open new window, N lines high',
    \ 'CTRL-W o	close all but current window (like |:only|)',
    \ 'CTRL-W p	go to previous (last accessed) window',
    \ 'CTRL-W q	quit current window (like |:quit|)',
    \ 'CTRL-W r	rotate windows downwards N times',
    \ 'CTRL-W s	split current window in two parts, new window N lines high',
    \ 'CTRL-W t	go to top window',
    \ 'CTRL-W v	split current window vertically, new window N columns wide',
    \ 'CTRL-W w	go to N next window (wrap around)',
    \ 'CTRL-W x	exchange current window with window N (default: next window)',
    \ 'CTRL-W z	close preview window set window width to N columns',
    \ 'CTRL-W }	show tag under cursor in preview window',
    \ ' ',
    \ 'CTRL-W ?	filcab: Show help'
    \ ]

  redir => maps
  " get any extra maps
  silent map <C-w>
  redir END
  let lines += split(maps, "\n")

  let options = #{
    \ title: ' Default CTRL-W key bindings. Also work as C-w C-<whatever> ',
    \ padding: [0,1,0,1],
    \ border: [],
    \ filter: 'popup_filter_yesno',
    \ }
  call popup_dialog(lines, options)
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
