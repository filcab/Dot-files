" Windows installs a useless python3 in the path, let's filter it out
if has('win32unix')
  " ensure we use the mingw version of python, taking *NIX paths
  let s:pythonCmd = '/usr/bin/env python'
elseif executable('python3') && exepath('python3') !~? ".*AppInstallerPythonRedirector.exe"
  let s:pythonCmd = 'python3'
elseif executable('python')
  let s:pythonCmd = 'python'
else
  echoerr "Couldn't find python3 or python: UpdatePackages and RecompileYCM commands won't work"
endif

echom "update_packages' pythonCmd: " s:pythonCmd

" args: options to term_start()
function! filcab#update_packages#recompileYCM(...)
  " install different variants so we can control what library gets added
  if has("win32unix")
    let ycm_suffix = ".win32unix"
  elseif has("win32")
    let ycm_suffix = ".win32"
  else
    let ycm_suffix = ""
  endif

  " try to shutdown ycmd, like YCM does on bootup if needed
  if get(g:, 'loaded_youcompleteme', 0)
    " get the server to shutdown so windows allows us to overwrite the file
    py3 << trim EOF
      if 'ycm_state' in globals():
        ycm_state.OnVimLeave()
EOF
  " not indented above so we get back to vim syntax
  endif

  let recompileScript = $MYVIMRUNTIME.'/pack/filcab/recompile-ycm'
  if a:0 == 0
    echom  ":terminal" "++shell" s:pythonCmd shellescape(recompileScript) "opt/YouCompleteMe".ycm_suffix
    execute  ":terminal" "++shell" s:pythonCmd shellescape(recompileScript) "opt/YouCompleteMe".ycm_suffix
  else
    let options = {
	  \ 'term_name': 'YCM compilation',
	  \ 'norestore': v:true,
	  \ }
    let options = extend(options, a:1)
    let cmd = join([s:pythonCmd, recompileScript, "opt/YouCompleteMe".ycm_suffix], " ")
    echom "term_start(" cmd ", " options ")"
    return term_start(cmd, options)
  endif
endfunction

" argument: optional options for term_start() function
function! s:updatePackages(...)
  let myPackDir = $MYVIMRUNTIME.'/pack/filcab'
  " FIXME: Maybe in the future try and use :py3f in vim, but still have it be
  " async...

  if has("win32unix")
    let ycm_rename = "YouCompleteMe=YouCompleteMe.win32unix"
  elseif has("win32")
    let ycm_rename = "YouCompleteMe=YouCompleteMe.win32"
  else
    let ycm_rename = "YouCompleteMe=YouCompleteMe"
  endif

  let script = myPackDir."/get-files"
  let sourcesFile = myPackDir."/sources"

  if a:0 == 0
    " no exit_cb was provided
    " use shell escapes and the ++shell argument as otherwise we'll get split on
    " spaces. I couldn't find a proper way to quote the arguments whilst still
    " not using shell (quotes would end up getting included in the arguments
    " themselves)
    let script = shellescape(script)
    let sourcesFile = shellescape(sourcesFile)
    let cmd = join([s:pythonCmd, script, "-o", shellescape(myPackDir), "--rename", ycm_rename, sourcesFile], " ")
    echom ":terminal" "++noclose" "++shell" cmd
    execute ":terminal" "++noclose" "++shell" cmd
  else
    let options = {
	  \ 'term_name': 'Vim package updates',
	  \ 'norestore': v:true,
	  \ }
    let options = extend(options, a:1)
    let cmd = join([s:pythonCmd, script, "-o", myPackDir, "--rename", ycm_rename, sourcesFile], " ")
    echom "term_start(" cmd ", " options ")"
    return term_start(cmd, options)
  end
endfunction

" Function to run helptags on all the opt packages. Regular packages are
" already in |rtp|, so will have their helptags done with :helptags ALL
function! s:packOptHelpTags() abort
  for d in split(&packpath, ',')
    " skip any global plugins
    if stridx(d, $VIMRUNTIME) == 0
      continue
    endif

    " pack/$any/{opt,start}/$name/doc
    let dir = d.'/pack/*/*/*/doc'
    for doc in glob(dir, v:true, v:true)
      echom doc
      exe 'helptags '.fnameescape(doc)
    endfor
  endfor
endfunction

function! s:updatePackages_step2(job, status) abort
  if a:status == 0
    silent! helptags $MYVIMRUNTIME/**/doc
    call s:packOptHelpTags()
    " reuse the other term window if it's visible
    let bufnr = ch_getbufnr(a:job, "out")
    let winnr = bufwinnr(bufnr)
    if winnr == -1
      let options = {'term_opencmd': winnr..'wincmd w|buffer %d'}
    else
      let options = {}
    endif
    call filcab#update_packages#recompileYCM(options)
    " execute ":bdelete" bufnr
  else
    echohl WarningMsg
    echom "UpdatePackages: Failed to update all packages, not running recompile script"
    echohl None
  endif
endfunction

" maybe do away with the previous commands. This one should stop on any error
" anyway
function! filcab#update_packages#updatePackages() abort
  call s:updatePackages({'exit_cb': funcref('s:updatePackages_step2')})
endfunction
