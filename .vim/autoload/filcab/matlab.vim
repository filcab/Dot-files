" trim empty lines at the start and end of any lines sent to the repl
let g:repl_trim_outer_lines = get(g:, 'repl_trim_outer_lines', v:true)

" TODO: find out where octave is in a portable way
let s:tentative_octave_dir = "C:\\Program Files\\GNU Octave\\Octave-6.3.0"
" TODO: Set octave_dir/octave_executable from the other one, if only one is
" defined
let g:octave_dir = get(g:, 'octave_dir', s:tentative_octave_dir)
let g:octave_executable = get(g:, 'octave_executable', g:octave_dir."\\mingw64\\bin\\octave-gui.exe")

let s:default_repl_name = "Octave-REPL"
let g:octave_repl_name = get(g:, 'octave_repl_name', s:default_repl_name)

function! s:octaveReplExists(repl_name) abort
  let buf_num = bufnr(a:repl_name)
  return buf_num != -1 && term_getstatus(buf_num) !=# "finished"
endfunction

function! s:startNewRepl(repl_name, select_repl, use_curwin) abort
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

  let options = {"env": env, "term_name": a:repl_name, "curwin": a:use_curwin}
  call term_start([g:octave_executable, "--no-gui"], options)
  if !a:select_repl
    wincmd w
  endif
endfunction

function! s:switchToRepl(repl_name) abort
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

function! filcab#matlab#sendToOctaveREPL(repl_name = g:octave_repl_name) abort
  if !s:octaveReplExists(a:repl_name)
    call filcab#matlab#openOctaveREPL(a:repl_name, v:false)
  endif

  " TODO: Add operator-pending mode
  if mode() ==# "n"
    " normal mode, use range
    let lines = getline(a:firstline, a:lastline)
  elseif tolower(mode()) ==# "v"
    " regular or line visual mode
    echom "visual"
    let [from_lnum, from_col] = getpos("v")[1:2]
    let [to_lnum, to_col] = getpos(".")[1:2]

    " switch up the positions if from > to
    if from_lnum > to_lnum
      let [tmp_lnum, tmp_col] = [from_lnum, from_col]
      let [from_lnum, from_col] = [to_lnum, to_col]
      let [to_lnum, to_col] = [tmp_lnum, tmp_col]
    endif

    " adjust columns for line-visual mode
    if mode() ==# "V"
      let from_col = 1
      let to_col = 2147483647
    endif

    let lines = getline(from_lnum, to_lnum)
    let lines[0] = lines[0][from_col-1:]
    let lines[-1] = lines[-1][:to_col-1]
  elseif mode() ==# "i"
    let curline = line(".")
    let lines = getline(curline, curline)
  else
    echoerr "unsupported mode: ".mode()
  endif

  let lines = join(lines, "\n")
  if get(b:, 'repl_trim_outer_lines', g:repl_trim_outer_lines)
    let lines = trim(lines)
  endif

  if lines ==# ''
    echom "no text to send"
    return
  endif

  " ensure we end with a \n
  if lines[-1] !=# "\n"
    let lines .= "\n"
  endif

  " FIXME: escape things like \<cr> otherwise they'll be replaced with the
  " unescaped sequence. For now this should be ok
  echom "sending: " lines
  let buf = bufnr(a:repl_name)
  call term_sendkeys(buf, lines)
endfunction

function! filcab#matlab#openOctaveREPL(repl_name = g:octave_repl_name, select_repl = v:true) abort
  if s:octaveReplExists(a:repl_name)
    if a:select_repl
      call s:switchToRepl(a:repl_name)
    endif
  else
    " remove the old, finished REPL, if there is one
    let buf_num = bufnr(a:repl_name)
    call s:startNewRepl(a:repl_name, a:select_repl, buf_num != -1)

    if buf_num != -1
      exe "bwipeout" buf_num
    endif
  endif
endfunction
