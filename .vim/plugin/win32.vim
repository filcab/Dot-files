if !has('win32') && !has('win32unix')
  finish
endif

" Always use proper slashes on Windows if our shell looks like a *NIX one.
" Windows shell settings require special care so they always work on:
"   - Regular Windows (gvim.exe)
"   - With and without winpty:
"     - git-bash running installed (up-to-date) vim (same installation as previous gvim.exe)
"     - git-bash running an older vim.exe (distributed with it)
" 2021-11-09: Previously, I'd set the shell to cmd.exe on all Windows
" executions. Let's try just on win32, but not on win32unix
  " 2021-11-09: When executing gvim from a git-for-windows shell, we end up
  " with &shell=='', as well as a Windows &shellcmdflag=='/c'
" 2022-11-03: weirdly, it looks like, when calling gvim from git-bash, &shell
" starts as: '"C:/Program Files/Git/usr/bin/bash.exe" ' (the double quotes and
" space are included). This means that our executable check will fail and we
" will set the shell to cmd.exe. This seems appropriate
" echom "filcab: switching &shell from" &shell "=>" executable(&shell)
" echom "filcab: lolwut:" &shell[1:-1] "=>" executable(&shell[1:-2])
if executable(&shell) != 1
  " Our 'shell' option is invalid. Possibly due to / vs \ and dirs with
  " spaces. Revert to the Windows default.
  set shell=C:\\WINDOWS\\system32\\cmd.exe
  " also set $SHELL so any subprocesses hopefully behave ok
  let $SHELL=&shell
  set shellxquote=(
  set shellcmdflag=/c
  " Other shell options seem the same between Windows and git-bash vim
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

" FIXME: vim from git-bash will crash upon loading python if it was invoked
" from git commit as an editor. Let's not issue any 'py3' commands if it looks
" like that's the case, those editors are very short-lived anyway
" don't do this if we're opening a file to edit a commit message, as it's most
" likely we won't do anything else
" only do this if "msys" doesn't appear in &pythonthreedll, which means we're
" using a normal windows python
if has('win32unix') && expand("%:t") !=# "COMMIT_EDITMSG" && stridx(&pythonthreedll, "msys") == -1
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
