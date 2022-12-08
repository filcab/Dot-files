" enable filecheck highlighting
if get(b:, 'filecheck_syntax_loaded', v:false) && get(g:, 'filecheck_auto_enable', v:false)
  runtime! syntax/filecheck.vim
  let b:filecheck_syntax_loaded = v:true
endif
