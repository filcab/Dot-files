" Possible completers we have
let s:completer_flavours = ["ycm", "lsp"]

let s:completer_functions = {}
let s:completer_functions["lsp"] = {
  \ "fixit": {-> execute(":LspCodeAction")},
  \ "get-type": {-> execute(":LspTypeDefinition")},
  \ "get-type-fast": {-> execute(":LspTypeDefinition")},
  \ "goto": {-> execute(":LspDefinition")},
  \ "goto-def": {-> execute(":LspDefinition")},
  \ "goto-decl": {-> execute(":LspDeclaration")},
  \ "refresh": {-> execute(":LspDocumentDiagnostics")},
  \ "get-doc": {-> execute(":YcmCompleter GetDoc")},
  \ "get-doc-fast": {-> execute(":YcmCompleter GetDocImprecise")},
  \ "get-parent": {-> execute(":YcmCompleter GetParent")},
  \ "goto-inc": {-> execute(":YcmCompleter GoToInclude")},
  \ "goto-refs": {-> execute(":YcmCompleter GoToReferences")},
  \ "goto-smart": {-> execute(":YcmCompleter GoToDefinitionElseDeclaration")},
  \ "stats": function('filcab#ShowYCMNumberOfWarningsAndErrors'),
  \ }
let s:completer_functions["ycm"] = {
  \ "refresh": {-> execute(":YcmForceCompileAndDiagnostics")},
  \ "goto": {-> execute(":YcmCompleter GoTo")},
  \ "goto-def": {-> execute(":YcmCompleter GoToDefinition")},
  \ "goto-decl": {-> execute(":YcmCompleter GoToDeclaration")},
  \ "goto-refs": {-> execute(":YcmCompleter GoToReferences")},
  \ "goto-smart": {-> execute(":YcmCompleter GoToDefinitionElseDeclaration")},
  \ "goto-inc": {-> execute(":YcmCompleter GoToInclude")},
  \ "get-type": {-> execute(":YcmCompleter GetType")},
  \ "get-type-fast": {-> execute(":YcmCompleter GetTypeImprecise")},
  \ "get-parent": {-> execute(":YcmCompleter GetParent")},
  \ "get-doc": {-> execute(":YcmCompleter GetDoc")},
  \ "get-doc-fast": {-> execute(":YcmCompleter GetDocImprecise")},
  \ "fixit": {-> execute(":YcmCompleter FixIt")},
  \ "stats": function('filcab#ShowYCMNumberOfWarningsAndErrors'),
  \ }

function s:call_completer_function(flavours, name)
  let l:Func = v:false
  for flavour in s:completer_flavours
    if index(a:flavours, flavour) != -1
      let l:Func = get(s:completer_functions[flavour], a:name)
      break
    endif
  endfor

  if l:Func == v:false
    echoerr "Completer ".a:flavours." has no function for ".a:name
    return
  endif
  redraw
  return l:Func()
endfunction

function s:set_mapping(map, lang_name, keys, name) abort
  exe a:map."noremap" "<buffer><unique><silent>" "<LocalLeader>".a:keys ":silent call"
    \ "<SID>call_completer_function(g:filcab#".a:lang_name."#completer_flavours, '".a:name."')<cr>"
endfunction

function filcab#completers#setup_mappings(lang_name) abort
  if exists("b:filcab_setup_ycm_and_lsp_mappings")
    return
  endif

  call s:set_mapping("n", a:lang_name, "<f5>", "refresh")
  call s:set_mapping("n", a:lang_name, "g", "goto")
  call s:set_mapping("n", a:lang_name, "gg", "goto")
  call s:set_mapping("n", a:lang_name, "gd", "goto-def")
  call s:set_mapping("n", a:lang_name, "gD", "goto-decl")
  call s:set_mapping("n", a:lang_name, "gr", "goto-refs")
  call s:set_mapping("n", a:lang_name, "gR", "goto-refs")
  call s:set_mapping("n", a:lang_name, "gdd", "goto-smart")
  """" C/C++ mode only, I guess
  " Bind to both lower and uppercase
  " FILCAB: Maybe override gf *if* we're sure there's a compilation database?
  " FILCAB: check https://github.com/martong/vim-compiledb-path
  call s:set_mapping("n", a:lang_name, "gi", "goto-inc")
  call s:set_mapping("n", a:lang_name, "t", "get-type-fast")
  call s:set_mapping("n", a:lang_name, "T", "get-type")
  call s:set_mapping("n", a:lang_name, "p", "get-parent")
  call s:set_mapping("n", a:lang_name, "P", "get-parent")
  call s:set_mapping("n", a:lang_name, "f", "fixit")
  call s:set_mapping("n", a:lang_name, "w", "stats")
  call s:set_mapping("n", a:lang_name, "W", "stats")
  let b:filcab_setup_ycm_and_lsp_mappings=1
endfunction
