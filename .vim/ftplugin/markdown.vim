if exists("b:did_ftplugin")
  finish
endif

packadd vim-markdown
if get(s:, 'first_call', v:true)
  runtime! OPT "vim-markdown/ftplugin/markdown.vim" "vim-markdown/ftplugin/markdown/*.vim"
  let s:first_call = v:false
endif

let b:did_ftplugin = 1
