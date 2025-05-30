set cmdheight=2

" Remove line numbers in :terminal buffers (when in normal mode)
augroup filcabTerminal
  autocmd!
  autocmd TerminalOpen * setlocal nonumber
augroup END

" make it easier to know which line we're on
" cursorline ends up behaving in funky ways in some colorthemes.
" Maybe think about bringing it back after we think about how to fix it.
" Anyway, backgrounds are likely to disappear for the cursorline line
"set cursorline
" add bold attribute to current line number when 'number' and 'cursorline' are
" set
set highlight+=Nb
" " alternative, for when we have set 'relativenumber' (don't want this in
" " general, as we're changing the number highlight for all numbers to bold,
" " then putting back the regular highlights for numbers before and after the
" " current line
" " set line numbers to have the bold attribute (on top of LineNr highlight group)
" set highlight+=nb
" " revert lines above and below the current line to the LineNr highlight group
" " (assumes it's not bold)
" set highlight+=a:LineNr
" set highlight+=b:LineNr

if executable("fzf")
  call filcab#fzf#install_fzf_and_keybindings()
endif

" from https://github.com/crux/crux-vimrc/blob/master/plugin/unicode.vim
" modify selected text using combining diacritics
command! -range -nargs=0 Overline        call s:CombineSelection(<line1>, <line2>, '0305')
command! -range -nargs=0 Underline       call s:CombineSelection(<line1>, <line2>, '0332')
command! -range -nargs=0 DoubleUnderline call s:CombineSelection(<line1>, <line2>, '0333')
command! -range -nargs=0 Strikethrough   call s:CombineSelection(<line1>, <line2>, '0336')

function! s:CombineSelection(line1, line2, cp)
  execute 'let char = "\u'.a:cp.'"'
  execute a:line1.','.a:line2.'s/\%V[^[:cntrl:]]/&'.char.'/ge'
endfunction

" interesting shortcuts, let's try them out
vnoremap  :Strikethrough<CR>
vnoremap __ :Underline<CR>

function! s:tmuxCopy(data)
  call system("tmux load-buffer -w -", a:data)
endfunction

function! s:tmuxPaste()
  let @" = system("tmux show-buffer")
endfunction

if getenv("TMUX") != v:null
  let g:filcab_tmux = v:true
  " default to always copying to tmux when copying to vim?
  augroup tmux_clipboard
    au!
    au TextYankPost * call s:tmuxCopy(@")
  augroup END
  " WARNING: tmuxPaste just "imports" the tmux buffer into @"
  " unfortunately, I couldn't find an easy way to replicate a basic 'p'
  " command
  command! -nargs=0 TmuxPaste call s:tmuxPaste()
  noremap <expr> <Leader>p <SID>tmuxPaste("p")
endif

" try to get bracketed paste mode to work
if &t_BE == ''
  let &t_BE = "\e[?2004h"
  let &t_BD = "\e[?2004l"
  let &t_PS = "\e[200~"
  let &t_PE = "\e[201~"
endif

function! s:updateEnvVarsFromTmux()
  let vars = systemlist("tmux show-env")
  for line in vars
    if line[0] == '-'
      continue
    endif

    let eqIdx = stridx(line, '=')
    let var = line[:eqIdx-1]
    let value = line[eqIdx+1:]
    call setenv(var, value)
  endfor
endfunction

command! -nargs=0 UpdateEnvVarsFromTmux call s:updateEnvVarsFromTmux()
