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
function! filcab#FindProgram(prog_name, dirs, ...)
  " allow having version suffixes at the end of the program name (e.g: clang14
  " or gcc-11)
  " globs aren't very flexible, so ensure we have one of:
  " * a number, then anything
  " * dash, then a number, then anything
  let maybe_suffixes = ['', '[0123456789]*', '-[0123456789]*']

  " First search the passed in dirs
  for dir in a:dirs
    if !isdirectory(dir)
      continue
    endif

    for suffix in maybe_suffixes
      let glob_expr = expand(dir) .. '/' .. a:prog_name .. suffix .. s:exe_suffix
      let l:maybe_prog = glob(glob_expr, v:true, v:true)
      if len(l:maybe_prog) > 0 && executable(l:maybe_prog[0]) == 1
        return l:maybe_prog[0]
      endif
    endfor
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
  if !get(g:, 'clang_format_path', 0)
    echoerr "Could not find clang-format"
  endif

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
