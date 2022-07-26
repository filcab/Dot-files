if exists("b:did_filcab_after_js_ftplugin")
  finish
endif

if get(g:, 'lsp_impl', '') == 'vim-lsp'
  setlocal omnifunc=lsp#complete
elseif get(g:, 'lsp_impl', '') == ''
  " clang-format integration: only used when we have no LSP implementation
  " available
  if has('python3')
    nnoremap <buffer><unique> <LocalLeader><Tab> :py3f $MYVIMRUNTIME/clang-format.py<cr>
    vnoremap <buffer><unique> <LocalLeader><Tab> :py3f $MYVIMRUNTIME/clang-format.py<cr>
    inoremap <buffer><unique> <C-Tab><Tab> <C-o>:py3f $MYVIMRUNTIME/clang-format.py<cr><cr>
  elseif has('python')
    nnoremap <buffer><unique> <LocalLeader><Tab> :pyf $MYVIMRUNTIME/clang-format.py<cr>
    vnoremap <buffer><unique> <LocalLeader><Tab> :pyf $MYVIMRUNTIME/clang-format.py<cr>
    inoremap <buffer><unique> <C-Tab><Tab> <C-o>:pyf $MYVIMRUNTIME/clang-format.py<cr><cr>
  else
    echom 'Python3/Python not available, skipping clang-format mappings'
  endif

  if executable(g:clang_format_path)
    let &equalprg=g:clang_format_path
    " seems this is failing due to different line ending expectations on Windows
    "let &formatprg=g:clang_format_path
  endif

  " might want to extract this, but I'm not using it that much
  augroup FilcabJavascriptFtAutoCommands
    autocmd!
    autocmd BufWritePre <buffer>
      \ if get(b:, 'clang_format_on_save', g:clang_format_on_save) |
      \   call filcab#ClangFormat() |
      \ endif
  augroup END

  function! FilcabJavascriptFtPluginUndo()
    setlocal omnifunc<
    nunmap <buffer> <LocalLeader><Tab>
    vunmap <buffer> <LocalLeader><Tab>
    iunmap <buffer> <C-Tab><Tab>
    autocmd! FilcabJavascriptFtAutoCommands
  endfunction

  " Add to the rest of the undo_ftplugin commands
  let b:undo_ftplugin .= "|call FilcabJavascriptFtPluginUndo()"
endif

let b:did_filcab_after_js_ftplugin = 1
