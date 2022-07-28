" valid lsp implementations
let s:lsp_impl_list = ["ycm", "vim-lsp"]

if has("win32unix")
  let s:ycm_name = "YouCompleteMe.win32unix"
elseif has("win32")
  let s:ycm_name = "YouCompleteMe.win32"
else
  let s:ycm_name = "YouCompleteMe"
endif

" This function just checks if the very basic plugin/youcompleteme.vim has
" been loaded. It doesn't validate the state of the server. That part is
" assumed to be ok and something that the lsp#ycm#ftplugin() function will
" handle
function! s:ycm_setup() abort
  call s:log(2, "setting up YCM")

  " YCM has already been loaded
  if get(g:, 'loaded_youcompleteme', v:false)
    let succeeded = py3eval('"ycm_state" in globals()')
    call s:log(2, "setting up YCM: already loaded. ycm_state is available?", succeeded)
    return succeeded
  endif

  " install different variants so we can control what library gets added
  call s:log(2, "setting up YCM: calling packadd", s:ycm_name)
  try
    " packadd will fail if the YCM bits haven't been compiled, so we need to
    " wrap it in try/endtry statements
    execute "packadd" s:ycm_name
  endtry

  if !get(g:, 'loaded_youcompleteme', v:false)
    echohl WarningMsg
    echo "could not find and load YouCompleteMe via packadd" s:ycm_name
    echohl None
    return v:false
  end

  " this function only runs after vim_starting is false, so ycm will
  " immediately try to load its python library and setup its state
  " if there's no ycm_state at this point, YCM failed to load its library
  let succeeded = py3eval('"ycm_state" in globals()')
  if !succeeded
    call s:log(2, "setting up YCM: ycm_state is available?", succeeded)
    return succeeded
  end

  " FIXME: submit a PR for YCM. It always complains about fugitive files in
  " big repos anyway.
  " Would be "nice" to be able to goto definition, but do we care?
  let g:ycm_filetype_blacklist = get(g:, 'ycm_filetype_blacklist', {})
  let g:ycm_filetype_blacklist['fugitive'] = 1

  return v:true
endfunction

" TODO: vim-lsp handling
function! s:vim_lsp_setup() abort
  echom "vim-lsp setup is not implemented yet!"
endfunction

" can_use and setup need to be in a non-impl-specific file, otherwise we
" should forward to filcab#lsp#$impl
let s:lsp_impl_setup = {
      \ "ycm": {->s:ycm_setup()},
      \ "vim-lsp": {->s:vim_lsp_setup()},
      \ }

" TODO: Maybe in the future allow for different LSP per language
" Might not be worth it, and each LSP implementation seems to setup a bit too
" much global state for that to work (though we can blacklist some filetypes)
function! filcab#lsp#setup() abort
  if get(g:, 'lsp_impl', '') != ''
    " already setup
    return
  end

  if has('vim_starting')
    " YouCompleteMe will postpone initialization until after VimEnter (check
    " its plugin/youcompleteme.vim). Let's do the same so we pick up just
    " after (if YCM was already loaded) its autocmd, or just in time for us to
    " packadd
    augroup filcabLspSetup
      autocmd!
      autocmd VimEnter * call filcab#lsp#setup()
    augroup END
    return
  end

  call s:log(2, "hello filcab#lsp#setup")
  for lsp_impl in get(g:, 'lsp_impls', s:lsp_impl_list)
    if index(s:lsp_impl_list, lsp_impl) < 0
      echohl WarningMsg
      echo "unknown lsp implementation:" lsp_impl
      echo None
      continue
    end

    " FIXME: Maybe send error output somewhere?
    " If YCM is available *but* errors (e.g: compiled bits aren't compiled),
    " do we want to show the error? Do we want to try another impl?
    if !s:lsp_impl_setup[lsp_impl]()
      echo "failed to setup" lsp_impl "lsp implementation"
      continue
    end

    let g:lsp_impl = lsp_impl
    call extend(g:filcab_features, ["lsp", g:lsp_impl])
    break
  endfor
endfunction

" \ "vim-lsp": {->...},
let s:lsp_impl_is_ready = {
      \ "ycm": {->filcab#lsp#ycm#is_ready()},
      \ }
let s:lsp_impl_ftplugin = {
      \ "ycm": {->filcab#lsp#ycm#ftplugin()},
      \ }

function! s:log(level, ...) abort
  if get(g:, 'lsp_verbosity', 0) >= a:level
    execute "echom" "'lsp'" "'"..join(a:000, " ").."'"
  endif
endfunction

" wait at most one second: 100 * 10ms
let s:ftplugin_max_retries = 100
let s:ftplugin_wait_time = 10
let s:ftplugin_num_retries = 0
function! filcab#lsp#ftplugin() abort
  call s:log(2, "call lsp#ftplugin. vim_starting:", has('vim_starting'))

  " if we're starting up, YCM hasn't yet connected, so we'll need to wait
  " let's assume other lsp implementations work similarly
  if has('vim_starting')
    call s:log(1, "vim is starting, setting up autocmd")
    autocmd VimEnter * call filcab#lsp#ftplugin()
    return
  endif

  if get(g:, 'lsp_impl', '') == ''
    call s:log(1, "lsp#ftplugin() is running but no lsp_impl is set")
    return
  end

  if s:ftplugin_num_retries < s:ftplugin_max_retries && !s:lsp_impl_is_ready[g:lsp_impl]()
    let s:ftplugin_num_retries = s:ftplugin_num_retries - 1
    call s:log(2, "setting timer for 10ms, then calling filcab#lsp#ftplugin()")
    call timer_start(s:ftplugin_wait_time, {->filcab#lsp#ftplugin()})
    return
  elseif s:ftplugin_num_retries == s:ftplugin_max_retries
    echohl WarningMsg
    echom "LSP server took too long to become ready. Reverting to no LSP"
    let g:lsp_impl = ''
    echohl None
    return
  endif

  if get(g:, 'lsp_impl', '') != ''
    call s:log(2, "call lsp#ftplugin for", g:lsp_impl)
    call s:lsp_impl_ftplugin[g:lsp_impl]()
  endif

  call filcab#lsp#install_mappings()
endfunction

function! s:install_mapping(map_type, keys, map_arg)
  " only setup the mapping if the plug mapping exists
  if maparg(a:map_arg, a:map_type) != ''
    execute a:map_type.'map' '<buffer><unique>' a:keys a:map_arg
  endif
endfunction

function! s:uninstall_mapping(map_type, keys, map_arg) abort
  " only remove the mapping if the plug mapping is what we expect
  if maparg(a:keys) == a:map_arg
    execute a:map_type.'unmap' '<buffer>' a:keys
  endif
endfunction

function! s:do_mappings(func) abort
  let map_type = 'n'
  let prefix = '<localleader>'

  " these are valid for ycm for sure. Needs checking with vim-lsp
  let mappings = {
        \ 'fw': "FindSymbolInWorkspace",
        \ 'fd': "FindSymbolInDocument",
        \ 'f': 'Fixit',
        \ '<tab>': 'Format',
        \ 'd': "GetDoc",
        \ 'p': "GetParent",
        \ 'T': "GetType",
        \ 't': "GetTypeFast",
        \ 'G': "GoTo",
        \ 'C': "GoToCallers",
        \ 'c': "GoToCallees",
        \ 'o': "GoToDocumentOutline",
        \ 'g': "GoToFast",
        \ 'i': "GoToInclude",
        \ 'r': "GoToReferences",
        \ 's': "GoToSymbol",
        \ 'R': "Rename",
        \ '<f5>': "Refresh",
        \ }

  for [keys, command] in items(mappings)
    call a:func(map_type, prefix..keys, '<plug>(FilcabLsp'.command.')')
  endfor
endfunction

function! filcab#lsp#install_mappings() abort
  if get(b:, 'filcab_lsp_mappings', v:false)
    return
  endif

  call s:do_mappings(funcref('s:install_mapping'))
  let b:filcab_lsp_mappings = v:true
endfunction

function! filcab#lsp#undo_mappings() abort
  if !get(b:, 'filcab_lsp_mappings', v:false)
    return
  endif

  call s:do_mappings(funcref('s:uninstall_mapping'))
  let b:filcab_lsp_mappings = v:false
endfunction
