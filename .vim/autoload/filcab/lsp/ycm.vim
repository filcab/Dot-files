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
  " TODO: Maybe add these commands (they're active in python at least)
  " GoToDeclaration
  " GoToDefinition
  " GoToType

  let subcommands = join(py3eval('ycm_state.GetDefinedSubcommands()'), "\n")

  if index(subcommands, "Fixit") != -1
      call s:ycm_mapping("Fixit")
  endif

  if index(subcommands, "Format") != -1
    call s:ycm_mapping("Format")
  endif

  call s:ycm_mapping("GetDoc")

  if index(subcommands, "GetParent") != -1
    call s:ycm_mapping("GetParent")
  endif

  " fallback to regular GetType if GetTypeImprecise is not supported
  let gettypefast = "GetTypeImprecise"
  if index(subcommands, gettypefast) == -1
    let gettypefast = "GetType"
  endif
  call s:ycm_mapping("GetTypeFast", gettypefast)
  call s:ycm_mapping("GetType", "GetType")

  " maybe have some goto-declaration/goto-definition/goto-implementation
  call s:ycm_mapping("GoTo")

  if index(subcommands, "GoToCallers") != -1
    call s:ycm_mapping("GoToCallers")
  endif
  if index(subcommands, "GoToCallees") != -1
    call s:ycm_mapping("GoToCallees")
  endif
  if index(subcommands, "GoToDocumentOutline") != -1
    call s:ycm_mapping("GoToDocumentOutline")
  endif

  let gotofast = "GoToImprecise"
  if index(subcommands, gotofast) == -1
    let gotofast = "GoTo"
  endif
  call s:ycm_mapping("GoToFast", gotofast)

  if index(subcommands, "GoToInclude") != -1
    call s:ycm_mapping("GoToInclude")
  endif

  call s:ycm_mapping("GoToReferences")
  call s:ycm_mapping("GoToSymbol")

  call s:ycm_mapping("Rename", "RefactorRename")
  call s:ycm_mapping("Refresh", ":YcmForceCompileAndDiagnostics")
endfunction
