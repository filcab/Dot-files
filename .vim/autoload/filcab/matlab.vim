" TODO: find out where octave is in a portable way
let s:tentative_octave_dir = "C:\\Program Files\\GNU Octave\\Octave-6.3.0"
" TODO: Set octave_dir/octave_executable from the other one, if only one is
" defined
let g:octave_dir = get(g:, 'octave_dir', s:tentative_octave_dir)
let g:octave_executable = get(g:, 'octave_executable', g:octave_dir."\\mingw64\\bin\\octave-gui.exe")

let s:default_repl_name = "Octave-REPL"
let g:octave_repl_name = get(g:, 'octave_repl_name', s:default_repl_name)

function! s:octaveReplExists(repl_name)
  let buf_num = bufnr(a:repl_name)
  return buf_num != -1 && term_getstatus(buf_num) !=# "finished"
endfunction

function! s:startNewRepl(repl_name)
  " following the instructions in octave.vbs
  let msys_path = g:octave_dir."\\usr"
  let msys_prefix = g:octave_dir."\\mingw64"
  let octave_PATH = msys_path."\\bin".";".g:octave_dir."\\mingw64\\bin".";".g:octave_dir."\\qt5\\bin".";".$PATH

  let env = {}
  let env["PATH"] = octave_PATH
  let env["MSYSTEM"] = "MINGW64"
  let env["MSYSTEM_PREFIX"] = msys_prefix
  let env["MINGW_PREFIX"] = msys_prefix
  let env["OCTAVE_HOME"] = msys_prefix
  let env["EXEPATH"] = msys_prefix."\\bin"
  let env["GNUTERM"] = "wxt"
  let env["QT_PLUGIN_PATH"] = g:octave_dir."\\mingw64\\qt5\\plugins"
  let env["GS"] = "gs"

  let options = {"env": env, "term_name": a:repl_name}
  call term_start([g:octave_executable, "--no-gui"], options)
endfunction

function! s:switchToRepl(repl_name)
  let win_num = bufwinnr(a:repl_name)
  if win_num == -1
    " buffer exists but is not open. split + switch to it
    split
    exe "buffer" a:repl_name
  else
    " buffer exists and is open, switch the cursor to it
    exe win_num "wincmd" "w"
  endif
endfunction

function! filcab#matlab#openOctaveREPL()
  if s:octaveReplExists(g:octave_repl_name)
    call s:switchToRepl(g:octave_repl_name)
  else
    " remove the old, finished REPL, if there is one
    let buf_num = bufnr(g:octave_repl_name)
    if buf_num != -1
      exe "bdelete" buf_num
    endif

    call s:startNewRepl(g:octave_repl_name)
  endif
endfunction
