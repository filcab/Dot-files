call filcab#javascript#init()
" Just do the clang-format mapping
call filcab#ClangToolMappings(v:true)
call filcab#completers#setup_mappings('javascript')
