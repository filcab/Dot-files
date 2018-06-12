""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-autoset: Automatically run vim commands depending on current buffer
" author: Filipe Cabecinhas
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists('g:loaded_autoset')
  finish
endif
let g:loaded_autoset = 1

" List of rules that the user will add to
let s:autoset_rules = []

function! s:IsValidRule(rule) abort
  map(copy(s:mandatory_entries), has_key(a:rule, v:val))
endfunction

" Hide s:autoset_rules, so user code doesn't add invalid rules
function! AutosetAddRule(rule) abort
  if type(rule) != v:t_dict
    echoerr 'Rule is invalid: Not a dictionary: ' . rule
    return
  endif

  if !has_key(rule, 'name')
    echoerr 'Rule is invalid: Has no "name" property: ' . rule
    return
  endif

  if !has_key(rule, 'filter')
    echoerr 'Rule is invalid: Has no "filter" property: ' . rule
    return
  endif

  rulename = rule.name
  if has_key(s:autoset_rules, rulename)
    echoerr 'Rule "' . rulename . '" already exists: ' . s:autoset_rules[rulename]
  endif

  " TODO: Maybe do a deepcopy() and some additional validation
  s:autoset_rules[rulename] = rule
endfunction

function! AutosetRemoveRule(rulename) abort
  if !has_key(s:autoset_rules, rulename)
    echoerr 'Rule named "' . rulename . '" does not exist'
    return
  endif

  remove(s:autoset_rules, rulename)
endfunction

function! AutosetClearRules() abort
  let s:autoset_rules = []
endfunction

function! AutosetGetRules() abort
  return deepcopy(s:autoset_rules)
endfunction
