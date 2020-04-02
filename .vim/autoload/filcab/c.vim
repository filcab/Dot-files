" TODO: Define defaults and let the user override first by setting the paths in vimrc
" let filcab#clang_tools_search_paths = []

" Set the global var as clang-format.py queries it
let g:clang_format_path = filcab#FindProgram('clang-format', filcab#clang_tools_search_paths)
if !executable(g:clang_format_path)
  " The clang-format.py script we use doesn't validate and spews stuff to
  " stderr. Just unset the variable if we didn't find the program.
  unlet g:clang_format_path
endif

function filcab#c#ClangFormat()
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
endfunction

" TODO: Let the user override by defining the var before we set it
let filcab#c#clang_check_path = filcab#FindProgram('clang-check', filcab#clang_tools_search_paths)
" clang-check functions
function s:ClangCheckImpl(cmd)
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
function filcab#c#ClangCheck()
  let l:filename = expand('%')
  if l:filename =~ '\.\(cpp\|cxx\|cc\|c\)$'
    call s:ClangCheckImpl(shellescape(g:clang_check_path) . " " . l:filename)
  elseif exists("s:clang_check_last_cmd")
    call s:ClangCheckImpl(s:clang_check_last_cmd)
  else
    echo "Can't detect file's compilation arguments and no previous clang-check invocation!"
  endif
endfunction

let filcab#c#clangd_path = filcab#FindProgram('clangd', filcab#clang_tools_search_paths)
