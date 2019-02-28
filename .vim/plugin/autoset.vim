""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-autoset: Automatically run vim commands depending on current buffer
" author: Filipe Cabecinhas
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists('g:loaded_autoset')
  finish
endif

" TODO: Let autoset run hooks
"       That way it's easy to do whatever we want with more convoluted
"       patterns

if !exists('g:autoset_verbose')
  let g:autoset_verbose = 0
endif

" FIXME: Eventually remove some of these to an autoload file

" List of rules that the user will add to
let s:autoset_rules = {}

function! AutosetInstall() abort
  augroup AutosetGroup
    autocmd!
    autocmd BufNewFile,BufEnter * call AutosetApplyRules()
  augroup END
endfunction

function! AutosetUninstall() abort
  augroup AutosetGroup
    autocmd!
  augroup END
endfunction

function! s:AutosetApplyRule(rule) abort
  if g:autoset_verbose
    echom 'autoset: Applying rule "' . a:rule.name . '"'
  endif

  if has_key(a:rule, 'cd')
    let cmd = 'chdir ' . a:rule.cd
    if g:autoset_verbose
      echom 'autoset:   exe "' . cmd . '"'
    endif
    exe cmd
  endif

  if has_key(a:rule, 'options')
    for [option, value] in items(a:rule.options)
      let cmd = 'let &' . option . '="' . escape(value, '\"') . '"'
      if g:autoset_verbose
        echom 'autoset:   exe "' . cmd . '"'
      endif
      exe cmd
    endfor
  endif

  if has_key(a:rule, 'let')
    for [option, value] in items(a:rule.let)
      let cmd = 'let ' . option . '="' . escape(value, '\"') . '"'
      if g:autoset_verbose
        echom 'autoset:   exe "' . cmd . '"'
      endif
      exe cmd
    endfor
  endif
endfunction

function! AutosetApplyRules() abort
  let path = expand('%:p')
  if g:autoset_verbose
    echom 'autoset: Using filename: "' . path . '"'
  endif
  for [name, rule] in items(s:autoset_rules)
    if g:autoset_verbose
      echom 'autoset: Trying rule "' . name . '":'
      "echom string(rule)
    endif
    if rule.filter(rule, path)
      call s:AutosetApplyRule(rule)
      " Stop after first match. Should we continue?
      return
    endif
  endfor
endfunction

function! s:IsValidRule(rule) abort
  map(copy(s:mandatory_entries), has_key(a:rule, v:val))
endfunction

" Default filter (for when none was passed):
" If rule.pattern matches path, return true
function! s:AutosetPathFilter(rule, path) abort
  let pattern = a:rule.pattern
  if get(a:rule, 'pattern_expand', 0)
    let pattern = expand(pattern)
  endif
  if g:autoset_verbose
    echom 'autoset: matching pattern: "'.pattern.'", with path: "'.a:path.'"'
  endif
  return a:path =~ pattern
endfunction

" Hide s:autoset_rules, so user code doesn't add invalid rules
function! AutosetAddRule(rule) abort
  if type(a:rule) != v:t_dict
    echoerr 'Rule is invalid: Not a dictionary: ' . string(a:rule)
    return
  endif

  if !has_key(a:rule, 'name')
    echoerr 'Rule is invalid: Has no "name" property: ' . string(a:rule)
    return
  endif

  if !has_key(a:rule, 'filter') && !has_key(a:rule, 'pattern')
    echoerr 'Rule is invalid: Has no "filter" nor "pattern" property: ' . string(a:rule)
    return
  endif

  let rulename = a:rule.name
  if has_key(s:autoset_rules, rulename)
    echoerr 'Rule "' . rulename . '" already exists: ' . string(s:autoset_rules[rulename])
    return
  endif

  let rule = deepcopy(a:rule)

  if !has_key(rule, 'filter') && has_key(rule, 'pattern')
    " Default for strings is to check if the current file path matches its
    " pattern
    let rule.filter = funcref('s:AutosetPathFilter')
  endif

  " TODO: Add additional checks
  let s:autoset_rules[rulename] = rule
  if g:autoset_verbose
    echom 'autoset: Added rule "' . rulename . ': ' . string(rule)
  endif
endfunction

function! AutosetRemoveRule(rulename) abort
  if !has_key(s:autoset_rules, rulename)
    echoerr 'Rule named "' . rulename . '" does not exist'
    return
  endif

  remove(s:autoset_rules, rulename)
endfunction

function! AutosetClearRules() abort
  let s:autoset_rules = {}
endfunction

function! AutosetGetRules() abort
  return deepcopy(s:autoset_rules)
endfunction

let g:loaded_autoset = 1
