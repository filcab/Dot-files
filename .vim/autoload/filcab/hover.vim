" placeholder popup for when no popup is open
let s:null_popup = {'id': 0, 'word': ''}
" tracks the current popup window and the current word
let s:current_popup = s:null_popup

" functions to be called, in sequence, to try and get information for hover
let g:hover_functions = get(g:, 'hover_functions', [])

function! filcab#hover#enable()
  augroup hovers
    autocmd! * <buffer>
    autocmd CursorHold,CursorHoldI <buffer> call filcab#hover#hover(expand("<cword>"))
  augroup end
endfunction

function! filcab#hover#disable()
  augroup hovers
    autocmd! * <buffer>
  augroup end
endfunction

function! filcab#hover#hover(word) abort
  if s:current_popup.word == a:word
    " we already have a popup open for this word
    " TODO: Should we look at the position in the buffer?
    " Don't think we need, as we automatically close popups if we move out of
    " the word
    return
  else
    call popup_close(s:current_popup.id)
  endif

  let ret = []
  " first do buffer-locals, then globals
  for dict in [b:, g:]
    for F in get(dict, 'hover_functions', [])
      let txt = F(a:word)
      if txt != ''
        let ret = insert(ret, txt, len(ret))
      endif
    endfor
  endfor

  let popup_id = popup_atcursor(ret->join('\n-------------\n'), {
        \ 'callback': {x -> s:popup_closed() }
        \ })
  let s:current_popup = {
        \ 'id': popup_id,
        \ 'word': a:word
        \ }
endfunction

function! s:popup_closed() abort
  let s:current_popup = s:null_popup
endfunction
