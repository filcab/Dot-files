" Load our common stuff as early as possible, don't wait until after/ftplugin.
" Calling this function multiple times is ok, all but the first call will be a
" no-op.
call filcab#c#init()

" Make ninja the default makeprg and make clang the default compiler (for errorformat)
compiler! clang

if filereadable('build.ninja')
  setlocal makeprg=ninja
" give priority to a plain 'build' directory
elseif filereadable('build/build.ninja')
  setlocal makeprg=ninja\ -C\ build
else
  globbed = glob('build*/build.ninja', v:true, v:true)
  if len(globbed) > 0
    " just pick the first one, we have no proper way to disambiguate
    let dir_name = expand(globbed[0].":h")
    let &l:makeprg='ninja -C ' . shellescape(dir_name)
  endif
endif
