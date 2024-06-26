" Calling this function multiple times is ok, all but the first call will be a
" no-op.
call filcab#c#init()
call filcab#lsp#ftplugin()

" Make ninja the default makeprg and make clang the default compiler (for errorformat)
compiler clang

" only set this if we don't have a local makeprg and the global is still 'make' (default)
if !&l:makeprg && &makeprg == 'make'
  if filereadable('build.ninja')
    let &l:makeprg=g:ninja
  " give priority to a plain 'build' directory
  elseif filereadable('build/build.ninja')
    let &l:makeprg=g:ninja .. " -C build"
  else
    let s:globbed = glob('build*/build.ninja', v:true, v:true)
    if len(s:globbed) > 0
      " just pick the first one, we have no proper way to disambiguate
      let dir_name = fnamemodify(s:globbed[0], ":h")
      let &l:makeprg=g:ninja .. join([" -C", shellescape(dir_name)], " ")
      echom "found a build.ninja at:" dir_name..". setting makprg to:" &l:makeprg
    endif
  endif
endif

