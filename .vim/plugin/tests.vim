command -nargs=0 -bar EnableMatchUp packadd vim-matchup

" make it easier to know which line we're on
set cursorline
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
