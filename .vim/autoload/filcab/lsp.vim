" valid lsp implementations
let s:lsp_impl_list = ["ycm", "vim-lsp"]

function! s:YCMName() abort
  if has("win32unix")
    return "YouCompleteMe.win32unix"
  elseif has("win32")
    return "YouCompleteMe.win32"
  else
    echomsg "unknown vim version: not win32unix nor win32"
    return "YouCompleteMe"
  endif
endfunction
let s:ycm_name = s:YCMName()

function! s:ycm_setup() abort
  " YCM has already been loaded
  if get(g:, 'loaded_youcompleteme', v:false)
    return v:true
  endif

  " install different variants so we can control what library gets added
  if has("win32unix")
    packadd YouCompleteMe.win32unix
  elseif has("win32")
    packadd YouCompleteMe.win32
  else
    echomsg "unknown vim version: not win32unix nor win32"
    packadd YouCompleteMe
  endif

  if !get(g:, 'loaded_youcompleteme', v:false)
    echohl WarningMsg
    echo "could not load YouCompleteMe: Maybe it wasn't found?"
    echohl None
    return v:false
  end

  " FIXME: submit a PR for YCM. It always complains about fugitive files in
  " big repos anyway.
  " Would be "nice" to be able to goto definition, but do we care?
  let g:ycm_filetype_blacklist = get(g:, 'ycm_filetype_blacklist', {})
  let g:ycm_filetype_blacklist['fugitive'] = 1

  call filcab#lsp#ycm#init()
  return v:true
endfunction

" TODO: vim-lsp handling
function! s:vim_lsp_setup() abort
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

  for lsp_impl in get(g:, 'lsp_impls', s:lsp_impl_list)
    if index(s:lsp_impl_list, lsp_impl) < 0
      echohl WarningMsg
      echo "unknown lsp implementation:" lsp_impl
      echo None
      continue
    end

    if !s:lsp_impl_setup[lsp_impl]()
      echo "prerequisites failed for" lsp_impl "lsp implementation"
      continue
    end

    let g:lsp_impl = lsp_impl
    break
  endfor
endfunction

function! filcab#lsp#packaddYCM()
  if get(g:, 'ycm_enable', 0)
    return
  endif
  " install different variants so we can control what library gets added
  if has("win32unix")
    packadd YouCompleteMe.win32unix
  elseif has("win32")
    packadd YouCompleteMe.win32
  else
    echomsg "unknown vim version: not win32unix nor win32"
    packadd YouCompleteMe
  endif
  " FIXME: submit a PR for YCM. It always complains about fugitive files in
  " big repos anyway.
  " Would be "nice" to be able to goto definition, but do we care?
  let g:ycm_filetype_blacklist = get(g:, 'ycm_filetype_blacklist', {})
  let g:ycm_filetype_blacklist['fugitive'] = 1
endfunction

function! filcab#lsp#ShowYCMNumberOfWarningsAndErrors()
  if !get(g:, 'disable_youcompleteme', v:false) && get(g:, 'loaded_youcompleteme', v:false)
    echo 'YCM reports: Errors: ' . youcompleteme#GetErrorCount()
        \ . ' Warnings: ' . youcompleteme#GetWarningCount()
  endif
endfunction

" s:install_mapping(keys, command, map_type='n')
function! s:install_mapping(keys, command, ...)
  let map_type = 'n'
  if a:0 > 0
    let map_type = a:1
  end

  execute map_type.'map' '<buffer><unique>' '<localleader>'.a:keys '<plug>(FilcabLsp'.a:command.')'
endfunction

function! filcab#lsp#install_mappings() abort
  " these are valid for ycm for sure. Needs checking with vim-lsp
  call s:install_mapping('f', 'Fixit')
  call s:install_mapping('<tab>', 'Format')
  call s:install_mapping('d', "GetDoc")
  call s:install_mapping('p', "GetParent")
  call s:install_mapping('T', "GetType")
  call s:install_mapping('t', "GetTypeFast")
  call s:install_mapping('G', "GoTo")
  call s:install_mapping('C', "GoToCallers")
  call s:install_mapping('c', "GoToCallees")
  call s:install_mapping('o', "GoToDocumentOutline")
  call s:install_mapping('g', "GoToFast")
  call s:install_mapping('i', "GoToInclude")
  call s:install_mapping('r', "GoToReferences")
  call s:install_mapping('s', "GoToSymbol")
  call s:install_mapping('R', "Rename")
  call s:install_mapping('<f5>', "Refresh")
endfunction
