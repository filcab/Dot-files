" invoke vim like this to use the debug python library:
" vim --cmd 'let g:filcab_vim_python_use_debug=v:true' ...
let g:filcab_vim_python_use_debug = get(g:, 'filcab_vim_python_use_debug', v:false)

" search for a system-wide python3 and set pythonthreedll
" This is needed so git-for-windows' vim can find the system installed python3 dll
" Only set it if it's not already set to something readable
function! s:set_pythonthreedll() abort
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
      " unsure when this happens nowadays
      echom 'setting pythonthreedll from' &pythonthreedll 'to' globbed[0]
      let &pythonthreedll = globbed[0]
    endif
  endif
endfunction

if has('win32') || has('win32unix')
  call s:set_pythonthreedll()
  " adjust the temporary file directory as mingw vim will set TMP, etc to
  " /tmp, which other libraries (loaded python) won't know what to do with
  " know what to do with and will fallback to the SYSTEM temp dir
  " and will fallback to the SYSTEM temp dir
  " TODO: should we instead be setting $TMP on the python stuff? It's not set
  " by default (but vim's is)
  py3 import tempfile
  let cygpath_tmp = system('cygpath -m "$TMP"')->trim()
  execute "py3" "tempfile.tempdir" "=" "'".fnameescape(cygpath_tmp)."'"

  " let python know where our HOME is (YCM needs this)
  py3 import os
  let cygpath_home = system('cygpath -m "$USERPROFILE"')->trim()
  execute "py3" "os.environ['USERPROFILE']" "=" "'".fnameescape(cygpath_home)."'"
endif

" python for windows doesn't install an executable named python3, so pymode
" will just fail to see that we have python
" This needs to be done before pymode is loaded, or they'll set the variable
" to 'disable' and just break down
if has('python3') || has('python3/dyn')
  let g:pymode_python = 'python3'
endif
