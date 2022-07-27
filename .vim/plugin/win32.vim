if !has('win32') && !has('win32unix')
  finish
endif

" We need this call to execute befor has('python3') gets enabled on win32unix
" (at least)
call filcab#python_win32#set_pythonthreedll()

" python for windows doesn't install an executable named python3, so pymode
" will just fail to see that we have python
" This needs to be done before pymode is loaded, or they'll set the variable
" to 'disable' and just break down
if has('python3') || has('python3/dyn')
  let g:pymode_python = 'python3'
endif

if has('win32unix')
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
