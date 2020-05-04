" FIXME: Eventually hide these functions. But since they're only used for
" debugging, it's not a big deal.
function DebugSyntaxBalloon()
    let synID   = synID(v:beval_lnum, v:beval_col, 0)
    let groupID = synIDtrans(synID)
    let name    = synIDattr(synID, "name")
    let group   = synIDattr(groupID, "name")
    return name . "\n" . group
endfunction

function filcab#debug#syntax()
  set balloonexpr=DebugSyntaxBalloon()
  set ballooneval
endfunction
