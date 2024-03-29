" editing commands to make like easier
" abbreviate :vert sf ... and :vert sv ...
" completion is substandard. Ideally we'd complete any ++ to a ++opt
command -nargs=+ -bar -complete=file_in_path Vsf vert sfind <args>
command -nargs=+ -bar -complete=file_in_path Vsv vert sview <args>

" go to the first window with a terminal buffer
" FIXME: maybe in the future it'll go to the *next* terminal buffer?
command -nargs=0 -bar GotoTerminalWindow call filcab#gotoTermWindow()

" misc debugging/updating commands
command -nargs=0 -bar DebugSyntaxHighlights call filcab#debug#syntax()

" fetches new packages, rebuilds help tags for everything, and recompiles YCM
command -nargs=0 -bar UpdatePackages call filcab#update_packages#updatePackages()

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

" lazy load :Man command
command -nargs=+ -complete=shellcmd Man delcommand Man | runtime ftplugin/man.vim | :Man <args>
