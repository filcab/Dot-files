if exists("g:filcab_loaded_speeddating") || !exists("g:loaded_speeddating") || &cp || v:version < 700
  finish
endif

" From vim-speeddating/autoload/speeddating.vim
function s:function(name)
  return function(substitute(a:name,'^s:',matchstr(expand('<sfile>'), '.*\zs<SNR>\d\+_'),''))
endfunction

function s:compare_string_len(s1, s2)
  let len1 = strlen(a:s1)
  let len2 = strlen(a:s2)
  return len1 == len2 ? 0 : len1 < len2 ? 1 : -1
endfunction

function s:to_regexp(index, regexp)
  let regexp = a:regexp
  let prefix = (regexp[0] =~ '\k' ? '\<' : '')
  let suffix = (regexp[len(regexp)-1] =~ '\k' ? '\>' : '')
  return prefix.regexp.suffix
endfunction

" Handlers defined in this script. Will be prepended to g:speeddating_user_handlers
let s:speeddating_user_handlers = []

" Handlers to toggle true/false
let s:boolean_pairs = {}
let s:boolean_trues = {}
function s:boolean_add_pair(true, false)
  let s:boolean_trues[a:true] = 1
  let s:boolean_pairs[a:true] = a:false
  let s:boolean_pairs[a:false] = a:true
endfunction

function s:boolean_pairs_regexp()
  " Get the longest strings first, in the case of clashes. Meta-characters
  " count too, but this shouldn't be a problem.
  " Sigh... Due to the ! and #, it's not possible to just use \<\>. Zero-width
  " assertiong didn't work and I paused that attempt for now.
  let regexps = map(sort(keys(s:boolean_pairs), s:function('s:compare_string_len')), s:function('s:to_regexp'))
  return join(regexps, '\|')
endfunction

call s:boolean_add_pair('true', 'false')
call s:boolean_add_pair('True', 'False')
call s:boolean_add_pair('TRUE', 'FALSE')
call s:boolean_add_pair('#t', '#f')
call s:boolean_add_pair('T', 'NIL')
call s:boolean_add_pair('t', 'nil')
call s:boolean_add_pair('!nullptr', 'nullptr')
call s:boolean_add_pair('!NULL', 'NULL')

function s:boolean_calculate(string, increment)
  " Force true/false if abs(increment) > 1
  if a:increment > 1
    if get(s:boolean_trues, a:string, 0) == 1
      return a:string
    else
      return s:boolean_pairs[a:string]
    endif
  elseif a:increment < -1
    if get(s:boolean_trues, a:string, 0) == 1
      return s:boolean_pairs[a:string]
    else
      return a:string
    endif
  endif
  return s:boolean_pairs[a:string]
endfunction

" If increment is not 1 (or -1), we return the positive (or negative) version
" of that boolean, instead of simply toggling.
function s:boolean_toggle(string,offset,increment)
  return [s:boolean_calculate(a:string, a:increment),-1]
endfunction
let s:speeddating_user_handlers += [{'regexp': s:boolean_pairs_regexp(), 'increment': s:function("s:boolean_toggle")}]

let g:speeddating_user_handlers = s:speeddating_user_handlers + get(g:, 'speeddating_user_handlers', [])
let g:filcab_loaded_speeddating = 1
