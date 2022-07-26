" Load our common stuff as early as possible, don't wait until after/ftplugin.
" Calling this function multiple times is ok, all but the first call will be a
" no-op.
call filcab#javascript#init()
call filcab#lsp#install_mappings()
