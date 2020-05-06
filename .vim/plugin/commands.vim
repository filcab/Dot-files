" Lazy load WhichKey on first use (just has two commands anyway), and have the
" commands be replaced
command -bang -nargs=1 WhichKey delcommand WhichKey WhichKeyVisual | packadd vim-which-key | WhichKey<bang> <args>
" no need to forward the range
command -bang -nargs=1 -range WhichKeyVisual delcommand WhichKey WhichKeyVisual | packadd vim-which-key | WhichKeyVisual<bang> <args>

command -nargs=0 -bar RebuildMyHelptags helptags ALL | call filcab#packOptHelpTags()
command -nargs=0 -bar DebugSyntaxHighlights call filcab#debug#syntax()
command -nargs=0 -bar RecompileYCM call filcab#recompileYCM()
