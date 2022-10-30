" placeholder popup for when no popup is open
let s:null_popup = {'id': 0, 'word': ''}
" tracks the current popup window and the current word
let s:current_popup = s:null_popup

" let s:separator = "-------------"

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

  let accumulated = []
  " first do buffer-locals, then globals
  for dict in [b:, g:]
    for F in get(dict, 'hover_functions', [])
      let txt = F(a:word)
      echom "txt: " txt
      if len(txt) == 0
        " continue
      else
        let accumulated = txt
        break
      endif

      " just return the first function that returns anything useful. Let the
      " functions do the work of merging things?
      " keeping the older 'accumulating' code for a bit, commented out
      " if !empty(accumulated)
      "   let accumulated = add(accumulated, s:separator)
      " endif
      " let accumulated = extend(accumulated, txt)
    endfor
    if len(accumulated) > 0
      break
    endif
  endfor

  if len(accumulated) == 0
    return
  endif

  echom "accumulated:" accumulated
  let popup_id = popup_atcursor(accumulated, {
        \ 'callback': {x -> s:popup_closed() }
        \ })
  let s:current_popup = { 'id': popup_id, 'word': a:word }

  " hack: copy &ft, for now. Should change to textprop or have a way for the
  " functions to signal what we should do
  call win_execute(popup_id, 'set ft='..&ft)
endfunction

function! s:popup_closed() abort
  let s:current_popup = s:null_popup
endfunction
