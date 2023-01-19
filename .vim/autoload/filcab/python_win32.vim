" invoke vim like this to use the debug python library:
" vim --cmd 'let g:filcab_vim_python_use_debug=v:true' ...
let g:filcab_vim_python_use_debug = get(g:, 'filcab_vim_python_use_debug', v:false)

" search for a system-wide python3 and set pythonthreedll
" This is needed so git-for-windows' vim can find the system installed python3 dll
" Only set it if it's not already set to something readable
function! filcab#python_win32#set_pythonthreedll() abort
  if filereadable(&pythonthreedll)
    " nothing needed, it's already readable
    return
  endif

  let whereCmd = 'where '.shellescape(&pythonthreedll)
  let whereOutput = trim(system(whereCmd))
  " if `where` can find the dll, adjust for the debug version or just leave it
  " be, as the option will work
  if g:filcab_vim_python_use_debug
    " just in case, keep the extension around
    let extension = fnamemodify(whereOutput, ":e")
    let stem = fnamemodify(whereOutput, ":r")
    let maybeDebugDLL = stem."_d.".extension
    if filereadable(maybeDebugDLL)
      let whereOutput = maybeDebugDLL
      let &pythonthreedll = maybeDebugDLL
    endif
  endif

  if !filereadable(whereOutput)
    let pythonexe = exepath('python')
    " Let's assume it's python3, as it's 2020 now...
    " Remember to add the 3 after python
    let pythondir = fnamemodify(pythonexe, ':p:h')

    " Avoid the python3.dll file, which doesn't work, and allow any number of
    " trailing digits, like python37.dll, python38.dll, etc
    " have the * at the start so we match python310.dll, but don't match
    " python310_d.dll (unless filcab_vim_python_use_debug is set)
    let globstr = pythondir.'/python*[0-9][0-9]'
    if g:filcab_vim_python_use_debug
      let globstr .= '_d'
    endif
    let globstr .= '.dll'

    let globbed = glob(globstr, v:true, v:true)
    if globbed->len() != 1
      " just a minor sanity check
      echoerr "plugin/vim-python: weird python glob() result:" string(globbed)
      echom "pythonthreedll not set!"
    else
      " echom 'setting pythonthreedll from' &pythonthreedll 'to' globbed[0]
      let &pythonthreedll = globbed[0]
    endif
  endif

  " for some reason, we started to need this on py3.11 on Windows...
  py3 import sys; sys.path.append(sys.path[2] + '\\\\DLLs')
endfunction
