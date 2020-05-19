" Lazy load WhichKey on first use (just has two commands anyway), and have the
function s:InstallWhichKey() abort
  delcommand WhichKey
  delcommand WhichKeyVisual
  packadd vim-which-key
endfunction
command -bang -nargs=1 WhichKey call s:InstallWhichKey() | WhichKey<bang> <args>
" no need to forward the range
command -bang -nargs=1 -range WhichKeyVisual call s:InstallWhichKey() | WhichKeyVisual<bang> <args>

" lazy-load vim-characterize's single key binding on first use
nmap <silent> ga :unmap ga | packadd vim-characterize | normal ga
