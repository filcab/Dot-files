" haven't been able to get included files to work properly
function! FilCabCMakeIncludeExpr(fname) abort
  let matched = matchstr(a:fname, '^\s*\(add_subdirectory\|include\)\s*(\zs.*\ze)')
  let maybe_dir = simplify(expand('%:h') .. '/' ..  matched)
  let maybe_file = maybe_dir .. '/CMakeLists.txt'
  if filereadable(maybe_file)
    return maybe_file
  elseif isdirectory(maybe_dir)
    return maybe_dir
  endif
  return v:fname
endfunction

function! s:CMakeTryOpenSubdirCMakeLists() abort
  let line = getline('.')
  let maybe_file = FilCabCMakeIncludeExpr(line)
  execute ":edit" maybe_file
endfunction

setlocal matchpairs+=<:>
let &l:include = "\v\c^\s*(add_subdirectory|include)\s*\(\zs.*\ze\)"
let &l:define = "\v\c^\s*(macro|function)\s*\("
setlocal includeexpr=FilCabCMakeIncludeExpr(v:fname)
" this first one probably doesn't work, but it's hard to debug
setlocal suffixesadd=/CMakeLists.txt,.cmake

" testing: this may be a bit too much. Can be useful if we get "find in
" included files" working. Otherwise, we should just have path=.
let globbed = map(glob('./**/CMakeLists.txt', v:true, v:true),
      \           {key, val->fnamemodify(val, ":h")})
execute "setlocal" "path="..globbed->join(',')


noremap <buffer> <plug>(FilcabCMakeOpenSubdirCMakeLists) <cmd>execute ":edit" FilCabCMakeIncludeExpr(getline('.'))<cr>
map <buffer> ,g <plug>(FilcabCMakeOpenSubdirCMakeLists)
