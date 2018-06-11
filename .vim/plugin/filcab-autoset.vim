""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-autoset: Automatically run vim commands depending on current buffer
" author: Filipe Cabecinhas
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists('g:loaded_autoset')
  finish
endif
let g:loaded_autoset = 1

" List of rules that the user will add to
let g:autoset_rules = []

function! s:IsValidRule(rule) abort
  map(copy(s:mandatory_entries), has_key(a:rule, v:val))
endfunction

function! AutosetAddRule(rule) abort
  echo "AutosetAddRule: Not implemented yet"
endfunction

function! AutosetRemoveRule(rulename) abort
  echo "AutosetRemoveRule: Not implemented yet"
endfunction

function! AutosetClearRules() abort
  let g:autoset_rules = []
endfunction

