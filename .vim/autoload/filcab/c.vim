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

let g:clang_check_path = get(g:, 'clang_check_path',
    \ filcab#FindProgram('clang-check', g:clang_tools_search_paths))
if !executable(g:clang_check_path)
  echom "Can't find clang-check binary. Please set g:clang_tools_search_paths or g:clang_check_path"
endif

let g:clangd_path = get(g:, 'clangd_path',
    \ filcab#FindProgram('clangd', g:clang_tools_search_paths))
if !executable(g:clangd_path)
  echom "Can't find clangd binary. Please set g:clang_tools_search_paths or g:clangd_path"
else
  let g:ycm_clangd_binary_path = g:clangd_path
endif

function filcab#c#ClangFormat()
  " Doesn't do any verification. We've warned before.
  if !has('python') && !has('python3')
    echo 'Could not clang-format. Python not available.'
    return
  endif

  let path = expand('%')
  if !filereadable(path)
    echom 'Not running clang-format: File is not readable: ' . path
    return
  elseif path =~# '^fugitive://' && !get(g:, 'clang_format_fugitive', v:false)
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

" Pass v:true if you just want clang-format mappings
function filcab#c#ClangToolMappings(...)
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

  nnoremap <buffer><silent><unique> <F5> :call filcab#c#ClangCheck()<CR><CR>
endfunction

let filcab#c#initted = v:false
let filcab#c#completer_flavour = 'none'
function filcab#c#init() abort
  if g:filcab#c#initted
    return
  endif

  if v:false && executable(g:clangd_path)
    echo "Setting up vim-lsp for C/C++"
    let g:filcab#c#completer_flavour = 'lsp'
    " If another language plugin uses YouCompleteMe, let's blacklist this type
    let g:ycm_filetype_blacklist['c'] = 1
    let g:ycm_filetype_blacklist['cpp'] = 1
    let g:ycm_filetype_blacklist['objc'] = 1
    let g:ycm_filetype_blacklist['objcpp'] = 1
    packadd async
    packadd vim-lsp
    call lsp#register_server({
            \ 'name': 'clangd',
            \ 'cmd': {server_info->[g:clangd_path]},
            \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
            \ })
    " FIXME: Move this to ftplugin
    autocmd FileType c,objc,cpp,objcpp setlocal omnifunc=lsp#complete
  elseif !g:disable_youcompleteme
    echo "Setting up YouCompleteMe for C/C++"
    let g:filcab#c#completer_flavour = 'ycm'
    packadd YouCompleteMe
  endif

  let g:filcab#c#initted = v:true
endfunction
