" Set the variable to an empty list if it wasn't set
let g:clang_tools_search_paths = get(g:, 'clang_tools_search_paths', [])

" Set the global var as clang-format.py queries it
let g:clang_format_path = get(g:, 'clang_format_path',
    \ filcab#FindProgram('clang-format', g:clang_tools_search_paths))
if !executable(g:clang_format_path)
  echom "Can't find clang-format binary. Please set g:clang_tools_search_paths or g:clang_format_path"
  " The clang-format.py script we use doesn't validate and spews stuff to
  " stderr. Just unset the variable if we didn't find the program.
  unlet g:clang_format_path
endif

" Only search for a clang-check and set the var if it doesn't have a value yet
if !get(g:, 'clang_check_path', v:false)
  let g:clang_check_path = filcab#FindProgram('clang-check', g:clang_tools_search_paths)
endif
if !executable(g:clang_check_path)
  echom "Can't find clang-check binary. Please set g:clang_tools_search_paths or g:clang_check_path"
endif

" Only search for a clangd and set the var if it doesn't have a value yet
if !get(g:, 'clangd_path', v:false)
  let g:clangd_path = filcab#FindProgram('clangd', g:clang_tools_search_paths)
endif

if !executable(g:clangd_path)
  echom "Can't find clangd binary. Please set g:clang_tools_search_paths or g:clangd_path"
else
  let g:ycm_clangd_binary_path = g:clangd_path
  let g:ycm_clangd_args = ["--query-driver=*"] + get(g:, 'clangd_args', [])
endif

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

let filcab#c#initted = v:false
let filcab#c#completer_flavours = []
function filcab#c#init() abort
  if g:filcab#c#initted
    return
  endif

  " Latch onto the YCM var and use those args for lsp too
  let g:ycm_clangd_args = get(g:, 'clangd_args', [])

  if !get(g:, 'disable_lsp', v:false) && executable(g:clangd_path)
    echo "Setting up vim-lsp for C/C++"
    call add(g:filcab#c#completer_flavours, 'lsp')
    call lsp#register_server({
            \ 'name': 'clangd',
            \ 'cmd': {server_info->[g:clangd_path] + g:ycm_clangd_args},
            \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
            \ })
  endif

  if !get(g:, 'disable_youcompleteme', v:false)
    echo "Setting up YouCompleteMe for C/C++"
    call add(g:filcab#c#completer_flavours, 'ycm')
    if executable(g:clangd_path)
      let g:ycm_clangd_binary_path = g:clangd_path
    endif
    call filcab#packaddYCM()
  endif

  let g:filcab#c#initted = v:true
endfunction
