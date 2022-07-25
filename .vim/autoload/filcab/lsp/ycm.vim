" arguments:
" ycm_mapping(plugname, command=':YcmCompleter '.plugname, map_type='n')
function! s:ycm_mapping(...) abort
  breakadd here
  let plug_name = a:1
  let ycm_command = a:1
  let ycm_command = ":<C-u>YcmCompleter ".a:1
  let map_type = "n"

  if a:0 >= 2
    if a:2[0] == ':'
      let ycm_command = ':<C-u>'.a:2[1:]
    else
      let ycm_command = ":<C-u>YcmCompleter ".a:2
    end
  end

  if a:0 >= 3
    let map_type = a:3
  end

  " simple map: straight to command
  " not using buffer-local plugs as:
  " * they're plugs, so won't be using any keys
  " * we only have a single lsp impl at any time, so no need to worry about
  "   clashes or different lsp per ft
  execute map_type."noremap" "<unique>" "<plug>(FilcabLsp".plug_name.")" ycm_command.'<cr>'
endfunction

function! filcab#lsp#ycm#init() abort
  call s:ycm_mapping("Fixit")
  call s:ycm_mapping("Format")
  call s:ycm_mapping("GetDoc")
  call s:ycm_mapping("GetParent")
  call s:ycm_mapping("GetTypeFast", "GetTypeImprecise")
  call s:ycm_mapping("GetType", "GetType")
  " maybe have some goto-declaration/goto-definition/goto-implementation
  call s:ycm_mapping("GoTo")
  call s:ycm_mapping("GoToCallers")
  call s:ycm_mapping("GoToCallees")
  call s:ycm_mapping("GoToDocumentOutline")
  call s:ycm_mapping("GoToFast", "GoToImprecise")
  call s:ycm_mapping("GoToInclude")
  call s:ycm_mapping("GoToReferences")
  call s:ycm_mapping("GoToSymbol")
  call s:ycm_mapping("Rename", "RefactorRename")
  call s:ycm_mapping("Refresh", ":YcmForceCompileAndDiagnostics")
endfunction
