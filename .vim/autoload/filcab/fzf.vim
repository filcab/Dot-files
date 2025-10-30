function! filcab#fzf#install_fzf_and_keybindings() abort
  " fzf might not have been cloned into the pack directory, guard against it
  " not being cloned
  let v:errmsg = ""
  silent! packadd fzf
  if v:errmsg != ""
    silent echom v:errmsg
    return
  endif

  silent! packadd fzf.vim
  if v:errmsg != ""
    echom v:errmsg
    return
  endif

  " some of these might be more useable if they're more accessible
  silent! nnoremap <unique> <leader>ff <Cmd>Files<cr>

  " add some maps to switch buffers/windows/etc with fzf
  silent! nnoremap <unique> <leader>fb <Cmd>Buffers<cr>
  silent! nnoremap <unique> <leader>fh <Cmd>History<cr>
  silent! nnoremap <unique> <leader>f: <Cmd>History:<cr>
  silent! nnoremap <unique> <leader>f/ <Cmd>History/<cr>
  silent! nnoremap <unique> <leader>ft <Cmd>Filetypes<cr>
  silent! nnoremap <unique> <leader>fw <Cmd>Windows<cr>

  " maybe not these?
  silent! nnoremap <unique> <leader>fc <Cmd>Commands<cr>
  silent! nnoremap <unique> <leader>fH <Cmd>Helptags<cr>
  silent! nnoremap <unique> <leader>fm <Cmd>Maps<cr>

  silent! nnoremap <unique> <leader>fl <Cmd>Lines<cr>
  silent! nnoremap <unique> <leader>fL <Cmd>BLines<cr>

  silent! nnoremap <unique> <leader>fg <Cmd>Commits<cr>
  silent! nnoremap <unique> <leader>fG <Cmd>BCommits<cr>

  silent! nnoremap <unique> <leader>f <Cmd>WhichKey "<space>"<cr>f

  call add(g:filcab_features, "fzf")
endfunction
