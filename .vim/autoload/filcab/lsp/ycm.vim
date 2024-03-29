" arguments:
" ycm_mapping(plugname, command=':YcmCompleter '.plugname, end='<cr>')
function! s:ycm_mapping(subcommands, ...) abort
  let plug_name = a:1
  let base_ycm_command = a:1
  let map_type = "n"

  let end_str = '<cr>'
  if a:0 >= 3
    let end_str = a:3
  end

  let nore = 'nore'
  if a:0 >= 2
    if a:2[0] == ':'
      let base_ycm_command = ''
      if end_str == '<cr>'
        let ycm_command = '<cmd>'..a:2[1:]
      else
        let ycm_command = ':<C-u>'..a:2[1:]
      endif
    elseif a:2[:5] ==? "<plug>"
      " <plug> mappings need can't have 'nore'(map) to function
      let nore = ''
      let base_ycm_command = ''
      let ycm_command = a:2
    else
      let base_ycm_command = a:2
    end
  end

  if base_ycm_command != ''
    if index(a:subcommands, base_ycm_command) == -1
      return
    end
    if end_str ==? "<cr>"
      let ycm_command = "<cmd>YcmCompleter "..base_ycm_command
    else
      let ycm_command = ":<c-u>YcmCompleter "..base_ycm_command
    endif
  end

  " unneeded for now
  " if a:0 >= 3
  "   let map_type = a:3
  " end

  " these are buffer local because different buffers with different languages
  " might have different commands
  let plug_cmd = "<plug>(FilcabLsp".plug_name.")"
  " on file reload, don't overwrite the command (should be defined to the same
  " thing anyway)
  if maparg(plug_cmd) == ''
    execute map_type..nore.."map" "<unique><buffer>" plug_cmd ycm_command..end_str
  endif
endfunction

function! filcab#lsp#ycm#is_ready() abort
  return py3eval('ycm_state.IsServerReady()')
endfunction

function! filcab#lsp#ycm#ftplugin() abort
  let subcommands = youcompleteme#GetDefinedSubcommands()
  if get(g:, 'lsp_verbosity', 0) >= 1
    echom "subcommands:" subcommands
  endif

  call s:ycm_mapping(subcommands, "Fixit")
  call s:ycm_mapping(subcommands, "Format")
  call s:ycm_mapping(subcommands, "GetDoc")
  call s:ycm_mapping(subcommands, "GetParent")

  " fallback to regular GetType if GetTypeImprecise is not supported
  call s:ycm_mapping(subcommands, "GetType", "GetType")
  let gettypefast = "GetTypeImprecise"
  if index(subcommands, gettypefast) == -1
    let gettypefast = "GetType"
  endif
  call s:ycm_mapping(subcommands, "GetTypeFast", gettypefast)

  " maybe have some goto-declaration/goto-definition/goto-implementation
  call s:ycm_mapping(subcommands, "GoTo")
  let gotofast = "GoToImprecise"
  if index(subcommands, gotofast) == -1
    let gotofast = "GoTo"
  endif
  call s:ycm_mapping(subcommands, "GoToFast", gotofast)

  call s:ycm_mapping(subcommands, "GoToCallers")
  call s:ycm_mapping(subcommands, "GoToCallees")
  call s:ycm_mapping(subcommands, "GoToDeclaration")
  call s:ycm_mapping(subcommands, "GoToDefinition")
  call s:ycm_mapping(subcommands, "GoToDocumentOutline")
  call s:ycm_mapping(subcommands, "GoToInclude")
  call s:ycm_mapping(subcommands, "GoToImplementation")
  call s:ycm_mapping(subcommands, "GoToReferences")

  " FIXME: Make the selected/pre-filled word smarter, if possible
  call s:ycm_mapping(subcommands, "GoToSymbol", "GoToSymbol", " <cword>")
  call s:ycm_mapping(subcommands, "GoToType", "GoToType", " <cword>")

  call s:ycm_mapping(subcommands, "Rename", "RefactorRename", " ")

  call s:ycm_mapping(subcommands, "Refresh", ":YcmForceCompileAndDiagnostics")
  call s:ycm_mapping(subcommands, "Stats", ":call <SID>ShowYCMNumberOfWarningsAndErrors()")

  call s:ycm_mapping(subcommands, "FindSymbolInWorkspace", "<plug>(YCMFindSymbolInWorkspace)")
  call s:ycm_mapping(subcommands, "FindSymbolInDocument", "<plug>(YCMFindSymbolInDocument)")

  call s:ycm_mapping(subcommands, "ToggleInlayHints", "<plug>(YCMToggleInlayHints)", "")
  call s:ycm_mapping(subcommands, "Hover", "<plug>(YCMHover)", "")

  call s:ycm_mapping(subcommands, "ShowDetailedDiagnostic", ":YcmShowDetailedDiagnostic ")

  if get(g:, 'lsp_verbosity', 0) >= 2
    for com in subcommands
      if !hasmapto(":<C-u>YcmCompleter "..com) && !hasmapto("<cmd>YcmCompleter "..com)
        echom "missing YcmCompleter command in plugs:" com
      endif
    endfor
  endif
endfunction

function! s:ShowYCMNumberOfWarningsAndErrors()
  if !get(g:, 'disable_youcompleteme', v:false) && get(g:, 'loaded_youcompleteme', v:false)
    echo 'YCM reports: Errors: ' . youcompleteme#GetErrorCount()
        \ . ' Warnings: ' . youcompleteme#GetWarningCount()
  endif
endfunction
