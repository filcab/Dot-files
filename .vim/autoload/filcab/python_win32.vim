" invoke vim like this to use the debug python library:
" vim --cmd 'let g:filcab_vim_python_use_debug=v:true' ...
let g:filcab_vim_python_use_debug = get(g:, 'filcab_vim_python_use_debug', v:false)

function! s:wherePython3() abort
  " assume the launcher is installed
  if executable('py')
    let lines = systemlist('py --list-paths')
    for line in lines
      if stridx(line, '*') == -1
        continue
      endif
      let exe = line->substitute('^[^*]\+\*\s\+', '', '')->trim()->substitute('\\', '/', 'g')
      let head = fnamemodify(exe, ":h")
      let stem = fnamemodify(exe, ":t:r")->substitute('\.', '', '')
      " ...python*3*.dll
      let dll = head .. '/' .. stem .. ".dll"
      if executable(dll)
        return dll
      endif
    endfor
  elseif executable('uv')
    let default_py = systemlist('uv python find default')[0]
    if filereadable(default_py)
      let default_py_dir = fnamemodify(default_py, ":p:h")
      if executable(default_py_dir .. "/python3t.dll")
        return default_py_dir .. "/python3t.dll"
      else
        return default_py_dir .. "/python3.dll"
      endif
    endif
  endif

  let whereCmd = 'where '.shellescape(&pythonthreedll)
  try
    let whereOutput = system(whereCmd)->split('\r\?\n\+')[0]
  catch
    echom "couldn't find a pythonthreedll"
    return v:none
  endtry
  return whereOutput
endfunction

" search for a system-wide python3 and set pythonthreedll
" This is needed so git-for-windows' vim can find the system installed python3 dll
" Only set it if it's not already set to something readable
function! filcab#python_win32#set_pythonthreedll() abort
  if filereadable(&pythonthreedll)
    " nothing needed, it's already readable
    return
  endif

  " hack it. prerequisite: symlink of the pythons in git-sdk-for-windows into
  " git-for-windows. or we can probably just always use the git-sdk for our
  " git stuff...
  " if has('win32unix')
  "   let whereOutput = "/usr/bin/"..&pythonthreedll
  " else
    let whereOutput = s:wherePython3()
  " endif

  " if `where` can find the dll, adjust for the debug version or just leave it
  " be, as the option will work
  if g:filcab_vim_python_use_debug
    " just in case, keep the extension around
    let extension = fnamemodify(whereOutput, ":e")
    let stem = fnamemodify(whereOutput, ":r")
    let maybeDebugDLL = stem."_d.".extension
    if filereadable(maybeDebugDLL)
      let whereOutput = maybeDebugDLL
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
  else
    let &pythonthreedll = whereOutput
  endif

  " for some reason, we started to need this on py3.11 on Windows...
  if stridx(&pythonthreedll, "msys") == -1
    " only needed if we're not using an msys python
    py3 import sys; sys.path.append(sys.path[2] + '\\\\DLLs')
  endif
endfunction
