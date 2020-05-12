" Lazy load WhichKey on first use (just has two commands anyway), and have the
" commands be replaced
command -bang -nargs=1 WhichKey delcommand WhichKey WhichKeyVisual | packadd vim-which-key | WhichKey<bang> <args>
" no need to forward the range
command -bang -nargs=1 -range WhichKeyVisual delcommand WhichKey WhichKeyVisual | packadd vim-which-key | WhichKeyVisual<bang> <args>

" misc debugging/updating commands
command -nargs=0 -bar DebugSyntaxHighlights call filcab#debug#syntax()
command -nargs=0 -bar RebuildHelptags helptags ALL | call filcab#packOptHelpTags()
command -nargs=0 -bar RecompileYCM call filcab#recompileYCM()
command -nargs=0 -bar UpdatePackages call filcab#updatePackages()

function s:ColorSchemeCommand(packname, schemename)
  exe "packadd" a:packname
  exe "colorscheme" a:schemename
endfunction

" FIXME: Trim this when we can... Just start removing colorschemes I don't like
command -nargs=0 TryMaterial call <SID>ColorSchemeCommand("material.vim", "material")
command -nargs=0 TryAyu call <SID>ColorSchemeCommand("ayu-vim", "ayu")
command -nargs=0 TryAurora call <SID>ColorSchemeCommand("vim-aurora", "aurora")
command -nargs=0 TryNeoDark call <SID>ColorSchemeCommand("neodark.vim", "neodark")
command -nargs=0 TryOne call <SID>ColorSchemeCommand("vim-one", "one")
