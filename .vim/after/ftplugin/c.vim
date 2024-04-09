" This is set in vim's ftplugin/c.vim which is loaded after our
" ftplugin/c.vim, so am setting it in after/ftplugin
" that file also gets loaded more times, so dump this *before* the check for
" did_filcab_after_c_ftplugin
setlocal commentstring=//%s

" This file will also be sourced by the cpp ftplugin
if exists("b:did_filcab_after_c_ftplugin")
  finish
endif

function! s:maybe_clang_format() abort
  if executable(get(g:, 'clang_format_path', ''))
    py3f $MYVIMRUNTIME/clang-format.py
  endif
endfunction

if get(g:, 'lsp_impl', '') == 'vim-lsp'
  setlocal omnifunc=lsp#complete
elseif get(g:, 'lsp_impl', '') == ''
  " clang-format integration: only used when we have no LSP implementation
  " available
  if has('python3')
    nnoremap <buffer><unique> <LocalLeader><Tab> <cmd>call <sid>maybe_clang_format()<cr>
    vnoremap <buffer><unique> <LocalLeader><Tab> <cmd>call <sid>maybe_clang_format()<cr>
    inoremap <buffer><unique> <C-Tab><Tab> <cmd>call <sid>maybe_clang_format()<cr>
  else
    echom 'Python not available, skipping clang-format mappings'
  endif

  if executable(get(g:, 'clang_format_path', ''))
    let &equalprg=g:clang_format_path
    " seems this is failing due to different line ending expectations on Windows
    "let &formatprg=g:clang_format_path
  endif

  " might want to extract this, but I'm not using it that much
  augroup FilcabCFtAutoCommands
    autocmd!
    autocmd BufWritePre <buffer>
      \ if get(b:, 'clang_format_on_save', get(g:, 'clang_format_on_save', '')) |
      \   call filcab#ClangFormat() |
      \ endif
  augroup END

  function! FilcabCFtPluginUndo()
    setlocal omnifunc<
    nunmap <buffer> <LocalLeader><Tab>
    vunmap <buffer> <LocalLeader><Tab>
    iunmap <buffer> <C-Tab><Tab>
    nunmap <buffer> <F5>
    autocmd! FilcabCFtAutoCommands
  endfunction

  " Add to the rest of the undo_ftplugin commands
  let b:undo_ftplugin .= "|call FilcabCFtPluginUndo()"
endif

" Always default to the clang compiler
compiler clang

" Extra clang-check keybinding. Mostly unused
nnoremap <buffer><silent><unique> <F5> <cmd>call filcab#c#ClangCheck()<cr>


let b:undo_ftplugin = get(b:, 'undo_ftplugin', '').."|call filcab#lsp#undo_mappings()|unlet b:did_filcab_after_c_ftplugin"
let b:did_filcab_after_c_ftplugin = 1
