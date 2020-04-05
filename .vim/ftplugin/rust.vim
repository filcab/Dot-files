packadd vim-rust

breakadd here
" Call filcab#rust before setting up the mappings as that sets up the LSP/YCM
call filcab#rust#ToolMappings()
call filcab#completers#setup_mappings()
