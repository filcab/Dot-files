" search for a system-wide python3 and set pythonthreedll
" This is needed so git-for-windows' vim can find the system installed python3 dll
" Only set it if it's not already set to something readable
if (has('win32') || has('win32unix')) && !filereadable(&pythonthreedll)
  let whereCmd = 'where '.shellescape(&pythonthreedll)
  let whereOutput = trim(system(whereCmd))
  " if `where` can find the dll, just leave it be, as the option will work
  if !filereadable(whereOutput)
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
      echom "pythonthreedll not set!"
    else
      " echom 'setting pythonthreedll from' &pythonthreedll 'to' globbed[0]
      let &pythonthreedll = globbed[0]
    endif
  endif
endif
