function! filcab#fzf#install_fzf_and_keybindings() abort
  " fzf might not have been cloned into the pack directory, guard against it
  " not being cloned
  let v:errmsg = ""
  silent! packadd fzf
  if v:errmsg != ""
    echom v:errmsg
    return
  endif

  silent! packadd fzf.vim
  if v:errmsg != ""
    echom v:errmsg
    return
  endif

  " add some maps to switch buffers/windows/etc with fzf
  nnoremap <unique> <leader>fb <Cmd>Buffers<cr>
  nnoremap <unique> <leader>fh <Cmd>History<cr>
  nnoremap <unique> <leader>f: <Cmd>History:<cr>
  nnoremap <unique> <leader>f/ <Cmd>History/<cr>
  nnoremap <unique> <leader>ft <Cmd>Filetypes<cr>
  nnoremap <unique> <leader>fw <Cmd>Windows<cr>

  " maybe not these?
  nnoremap <unique> <leader>fc <Cmd>Commands<cr>
  nnoremap <unique> <leader>fH <Cmd>Helptags<cr>
  nnoremap <unique> <leader>fm <Cmd>Maps<cr>

  nnoremap <unique> <leader>fl <Cmd>Lines<cr>
  nnoremap <unique> <leader>fL <Cmd>BLines<cr>

  nnoremap <unique> <leader>fg <Cmd>Commits<cr>
  nnoremap <unique> <leader>fG <Cmd>BCommits<cr>

  nnoremap <unique> <leader>f <Cmd>WhichKey "<space>"<cr>f

  call add(g:filcab_features, "fzf")
endfunction
