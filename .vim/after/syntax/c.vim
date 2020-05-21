" enable filecheck highlighting
if &syntax !~ 'filecheck' && get(g:, 'filecheck_auto_enable', v:false)
  setlocal syntax+=.filecheck
endif
