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
  return a:prog_name . '.NOTFOUND'
endfunction

" clang-format changed lines on save
let g:clang_format_on_save = 1  " Will query buffer-local variable of the same name first
" Have an escape hatch for fugitive buffers (usually a git diff), for now
let g:clang_format_fugitive = 1
function! s:ClangFormatOnSave()
  if (exists('b:clang_format_on_save') && b:clang_format_on_save) || g:clang_format_on_save
    if !has('python')
      echo 'Could not clang-format. Python not available.'
    endif

    if expand('%') == ''
      return
    elseif expand('%') =~# '^fugitive://' && !g:clang_format_fugitive
      return
    else
      let l:formatdiff = 1
      pyf ~/.vim/clang-format.py
    endif
  endif
endfunction
autocmd BufWritePre *.h,*.c,*.cc,*.cpp call s:ClangFormatOnSave()

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
    call ClangCheckImpl(g:clang_check_path . " " . l:filename)
  elseif exists("s:clang_check_last_cmd")
    call ClangCheckImpl(s:clang_check_last_cmd)
  else
    echo "Can't detect file's compilation arguments and no previous clang-check invocation!"
  endif
endfunction

function! CTRL_W_Help()
  echo 'Default CTRL-W key bindings. Also work as C-w C-<whatever>'
  echo 'command		   action in Normal mode'
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


let g:loaded_utilities = 1
