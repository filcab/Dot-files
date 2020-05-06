" search for a system-wide python3 and set pythonthreedll
" This is needed so git-for-windows' vim can find the system installed python3 dll
if has('win32')
  let pythonexe = exepath('python')
  " Let's assume it's python3, as it's 2020 now...
  " Remember to add the 3 after python
  let pythondir = fnamemodify(pythonexe, ':p:h')

  " Avoid the python3.dll file, which doesn't work, and allow any number of
  " trailing digits, like python37.dll, python38.dll, etc
  let globbed = glob(pythondir.'/python??*.dll', v:true, v:true)
  if globbed->len() != 1
    " just a minor sanity check
    echoerr "plugin/vim-python: weird python glob() result:" string(globbed)
  endif
  let &pythonthreedll = file
endif
