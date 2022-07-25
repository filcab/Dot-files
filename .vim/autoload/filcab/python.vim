let filcab#python#initted = v:false
let filcab#python#completer_flavours = []

let s:default_venv_names = ['venv', 'virtualenv']
" override point for users (must be done before this call)
let g:venv_names = get(g:, 'venv_names', s:default_venv_names)

function! filcab#python#find_venv() abort
  let current = expand("%")

  let next = fnamemodify(current, ":h")
  while current != next
    let current = next
    for attempt in g:venv_names
      let maybe_venv = current."/".attempt
      " TODO: check if other OS have other paths
      " TODO: venv vs virtualenv
      if isdirectory(maybe_venv) && filereadable(maybe_venv."/Scripts/activate")
        echom "python: found venv: ".maybe_venv
        return maybe_venv
      endif
    endfor

    let next = fnamemodify(current, ":h")
  endwhile
  return ''
endfunction

if len($VIRTUAL_ENV) != 0
  let g:pymode_virtualenv_enabled = v:true
  let g:pymode_virtualenv_path = $VIRTUAL_ENV
else
  " try autodetecting a venv
  let maybe_venv = filcab#python#find_venv()
  if maybe_venv != ''
    let g:pymode_virtualenv_enabled = v:true
    let g:pymode_virtualenv_path = maybe_venv
  endif
endif

function filcab#python#init() abort
  if g:filcab#python#initted
    return
  endif

  if executable('pylsp') != 1
    echoerr "pylsp not found, not enabling YCM or vim-lsp for python"
    return
  endif

  if get(g:, 'ycm_enable', v:false)
    echo "Setting up YouCompleteMe for Python"
    call add(g:filcab#python#completer_flavours, 'ycm')
    call filcab#lsp#packaddYCM()
  elseif get(g:, 'lsp_enable', v:false) && executable('pylsp')
    echo "Setting up vim-lsp for Python"
    call add(g:filcab#python#completer_flavours, 'lsp')
    packadd vim-lsp
    " pip install python-language-server
    call lsp#register_server({
      \ 'name': 'pylsp',
      \ 'cmd': {server_info->['pylsp']},
      \ 'whitelist': ['python'],
      \ })
  endif

  let g:filcab#python#initted = v:true
endfunction
