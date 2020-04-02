function filcab#CTRL_W_Help()
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

function filcab#CTRL_X_Help()
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

function filcab#ClangFormat()
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

" Find programs given search paths
let s:exe_suffix = has('win32') ? '.exe' : ''
function filcab#FindProgram(prog_name, dirs)
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
