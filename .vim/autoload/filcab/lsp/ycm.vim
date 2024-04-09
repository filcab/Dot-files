function! s:log(level, ...) abort
  if get(g:, 'lsp_verbosity', 0) >= a:level
    execute "echom" "'lsp'" '"'..join(a:000, " ")..'"'
  endif
endfunction

" arguments:
" ycm_mapping(subcommands, plugname, command='<cmd>YcmCompleter '..plugname, end='<cr>')
function! s:ycm_mapping(subcommands, options) abort
  let plug_name = a:options.plug_name
  let ycm_command = get(a:options, "ycm_command", plug_name)
  let end_str = get(a:options, "end", "<cr>")
  let cmd  = get(a:options, "command", ":YcmCompleter "..ycm_command)
  let map_type = get(a:options, "map_type", "n")

  let nore = 'nore'
  if cmd[0] == ':'
    if end_str == '<cr>'
      let cmd = '<cmd>'..cmd[1:]
    else
      let cmd = ':<C-u>'..cmd[1:]
    endif
  elseif cmd[:5] ==? "<plug>"
    " <plug> mappings need can't have 'nore'(map) to function
    let nore = ''
    let end_str = ''
  end

  " we didn't provide a command, so we're using the default, from the
  " plug_name
  if !has_key(a:options, "command") && index(a:subcommands, ycm_command) == -1
    call s:log(2, "ycm command", ycm_command, "does not exist in subcommands:", a:subcommands)
    return
  end

  " these are buffer local because different buffers with different languages
  " might have different commands, unless 'global' is specified as an option
  let plug_cmd = "<plug>(FilcabLsp"..plug_name..")"
  let maybe_buffer = get(a:options, "global") ? "" : "<buffer>"
  " don't make mappings <unique> as we might be re-defining after sourcing
  " this file
  execute map_type..nore.."map" maybe_buffer plug_cmd cmd..end_str
endfunction

let s:have_ensured_lsp_started = v:false
function! filcab#lsp#ycm#is_ready() abort
  " I couldn't find a better way to detect if we've connected to the server
  " (LSP, etc)
  " This seems to work with (at least) clangd and generic LSP
  return py3eval("'Server State: Initialized' in ycm_state.DebugInfo()")
endfunction

function! filcab#lsp#ycm#ftplugin() abort
  " the first time we're called on a new file (not the first one that triggers
  " ycm to launch, etc), we will be called *before* ycm does its thing, so
  " youcompleteme#GetDefinedSubcommands() won't return anything, even if the
  " server is initialized and will accept the file. Let's add a small delay so
  " we get called a few ms after the FileType event finishes. This is not
  " ideal, but I don't feel like polling for a bit until we give up.
  if !exists('b:ycm_completing')
    let wait_time = 16 " hopefully this is enough for any machine I use
    call s:log(2, "waiting", 16.."ms", "as ycm is not setup yet")
    call timer_start(wait_time, {->filcab#lsp#ycm#do_ftplugin()})
  else
    call filcab#lsp#ycm#do_ftplugin()
  endif
endfunction

function! filcab#lsp#ycm#do_ftplugin() abort
  let subcommands = youcompleteme#GetDefinedSubcommands()
  if len(subcommands) == 0
    call s:log(0, "got empty subcommands from YCM, not setting up any plug mappings")
  endif
  call s:log(1, "subcommands:", subcommands)

  call s:ycm_mapping(subcommands, {"plug_name": "ExecuteCommand"})
  call s:ycm_mapping(subcommands, {"plug_name": "Fixit"})  " clangd
  call s:ycm_mapping(subcommands, {"plug_name": "FixIt"})  " python-lsp
  call s:ycm_mapping(subcommands, {"plug_name": "Format"}) " map_type: n
  call s:ycm_mapping(subcommands, {"plug_name": "Format", "map_type": "v"})
  call s:ycm_mapping(subcommands, {"plug_name": "Format", "map_type": "i"})
  call s:ycm_mapping(subcommands, {"plug_name": "GetDoc"})
  call s:ycm_mapping(subcommands, {"plug_name": "GetParent"})

  " fallback to regular GetType if GetTypeImprecise is not supported
  call s:ycm_mapping(subcommands, {"plug_name": "GetType"})
  let gettypefast = "GetTypeImprecise"
  if index(subcommands, gettypefast) == -1
    let gettypefast = "GetType"
  endif
  call s:ycm_mapping(subcommands, {"plug_name": "GetTypeFast", "ycm_command": gettypefast})

  " maybe have some goto-declaration/goto-definition/goto-implementation
  call s:ycm_mapping(subcommands, {"plug_name": "GoTo"})
  let gotofast = "GoToImprecise"
  if index(subcommands, gotofast) == -1
    let gotofast = "GoTo"
  endif
  call s:ycm_mapping(subcommands, {"plug_name": "GoToFast", "ycm_command": gotofast})

  call s:ycm_mapping(subcommands, {"plug_name": "GoToCallers"})
  call s:ycm_mapping(subcommands, {"plug_name": "GoToCallees"})
  call s:ycm_mapping(subcommands, {"plug_name": "GoToDeclaration"})
  call s:ycm_mapping(subcommands, {"plug_name": "GoToDefinition"})
  call s:ycm_mapping(subcommands, {"plug_name": "GoToDocumentOutline"})
  call s:ycm_mapping(subcommands, {"plug_name": "GoToInclude"})
  call s:ycm_mapping(subcommands, {"plug_name": "GoToImplementation"})
  call s:ycm_mapping(subcommands, {"plug_name": "GoToReferences"})

  " FIXME: Make the selected/pre-filled word smarter, if possible
  call s:ycm_mapping(subcommands, {"plug_name": "GoToSymbol", "end": " <cword>"})
  call s:ycm_mapping(subcommands, {"plug_name": "GoToType", "end": " <cword>"})

  call s:ycm_mapping(subcommands, {"plug_name": "Rename", "ycm_command": "RefactorRename", "end": " "})

  call s:ycm_mapping(subcommands, {"plug_name": "Refresh", "command": ":YcmForceCompileAndDiagnostics"})
  call s:ycm_mapping(subcommands, {"plug_name": "RestartServer"})
  call s:ycm_mapping(subcommands, {"plug_name": "Stats", "command": ":call <SID>ShowYCMNumberOfWarningsAndErrors()"})

  call s:ycm_mapping(subcommands, {"plug_name": "FindSymbolInWorkspace", "command": "<plug>(YCMFindSymbolInWorkspace)", "global": v:true})
  call s:ycm_mapping(subcommands, {"plug_name": "FindSymbolInDocument", "command": "<plug>(YCMFindSymbolInDocument)"})

  call s:ycm_mapping(subcommands, {"plug_name": "ToggleInlayHints", "command": "<plug>(YCMToggleInlayHints)"})
  call s:ycm_mapping(subcommands, {"plug_name": "ToggleInlayHints", "command": "<plug>(YCMToggleInlayHints)", "map_type": "i"})
  call s:ycm_mapping(subcommands, {"plug_name": "ToggleSignatureHelp", "command": "<plug>(YCMToggleSignatureHelp)"})
  call s:ycm_mapping(subcommands, {"plug_name": "ToggleSignatureHelp", "command": "<plug>(YCMToggleSignatureHelp)", "map_type": "i"})
  call s:ycm_mapping(subcommands, {"plug_name": "GetHover"})
  call s:ycm_mapping(subcommands, {"plug_name": "Hover", "command": "<plug>(YCMHover)"})

  call s:ycm_mapping(subcommands, {"plug_name": "ShowDetailedDiagnostic", "command": ":YcmShowDetailedDiagnostic"})

  if get(g:, 'lsp_verbosity', 0) >= 2
    for com in subcommands
      if !hasmapto(":<C-u>YcmCompleter "..com) && !hasmapto("<cmd>YcmCompleter "..com)
        call s:log(2, "missing YcmCompleter command in plugs:", com)
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

" some unknown (to YCM) token types need some props set
" seems like c/c++ filetypes don't have these, but python do...
try
  call prop_type_add('YCM_HL_bracket', {})  " don't highlight brackets
catch
  " hide errors
endtry

try
  call prop_type_add('YCM_HL_label', { 'highlight': 'Special' })  " let's try this one for labels
catch
  " hide errors
endtry
