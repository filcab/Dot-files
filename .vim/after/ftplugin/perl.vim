setlocal cindent cinkeys='0{,0},!^F,o,O,e'
" formatoptions:
"   t - wrap text using textwidth
"   c - wrap comments using textwidth (and auto insert comment leader)
"   r - auto insert comment leader when pressing <return> in insert mode
"   o - auto insert comment leader when pressing 'o' or 'O'.
"   q - allow formatting of comments with "gq"
"   a - auto formatting for paragraphs
"   n - auto wrap numbered lists

let b:undo_ftplugin .= '|setlocal cindent< cinkeys<'
