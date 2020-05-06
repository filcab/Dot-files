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

function s:unset_mapping(map, lang_name, keys, name) abort
  set verbose=9
  exe a:map."nunmap" "<buffer>" "<LocalLeader>".a:keys
  set verbose=0
endfunction

function filcab#completers#setup_mappings(lang_name, ...) abort
  if exists("b:filcab_setup_ycm_and_lsp_mappings")
    return
  endif

  " FIXME: Make this an explicit argument
  let undo = get(a:, 1, v:false)
  if undo
    let DoMapping = function('s:unset_mapping')
  else
    let DoMapping = function('s:set_mapping')
  endif

  call DoMapping("n", a:lang_name, "<f5>", "refresh")
  call DoMapping("n", a:lang_name, "g", "goto")
  call DoMapping("n", a:lang_name, "gg", "goto")
  call DoMapping("n", a:lang_name, "gd", "goto-def")
  call DoMapping("n", a:lang_name, "gD", "goto-decl")
  call DoMapping("n", a:lang_name, "gr", "goto-refs")
  call DoMapping("n", a:lang_name, "gR", "goto-refs")
  call DoMapping("n", a:lang_name, "gdd", "goto-smart")
  """" C/C++ mode only, I guess
  " Bind to both lower and uppercase
  " FILCAB: Maybe override gf *if* we're sure there's a compilation database?
  " FILCAB: check https://github.com/martong/vim-compiledb-path
  call DoMapping("n", a:lang_name, "gi", "goto-inc")
  call DoMapping("n", a:lang_name, "t", "get-type-fast")
  call DoMapping("n", a:lang_name, "T", "get-type")
  call DoMapping("n", a:lang_name, "p", "get-parent")
  call DoMapping("n", a:lang_name, "P", "get-parent")
  call DoMapping("n", a:lang_name, "f", "fixit")
  call DoMapping("n", a:lang_name, "w", "stats")
  call DoMapping("n", a:lang_name, "W", "stats")
  let b:filcab_setup_ycm_and_lsp_mappings=1
endfunction
