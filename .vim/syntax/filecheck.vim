" FileCheck syntax file
" Language:   llvm, cpp
" Maintainer: The LLVM team, http://llvm.org/
" Version:      $Revision$

" If we've been loaded, don't redefine the functions, nor override any added
" prefixes/comments
if !get(g:, "filecheck_syntax_loaded", v:false)
  " Set default values, user can override globally or buffer-locally if needed
  let g:FileCheckPrefixes = get(g:, 'filecheck_prefixes', ["CHECK"])
  let g:FileCheckComments = get(g:, 'filecheck_comments', ["COM", "RUN"])

  function! s:prefixes() abort
    return get(b:, 'FileCheckPrefixes', g:FileCheckPrefixes)
  endfunction

  function! s:comments() abort
    return get(b:, 'FileCheckComments', g:FileCheckComments)
  endfunction

  let g:filecheck_syntax_loaded = v:true
endif

if version < 600
  syntax clear
elseif exists('b:current_syntax') && b:current_syntax =~ 'filecheck'
  finish
endif

syn case match

" Need to:
" create region for {CHECK_PREFIX}: .*
"   create highlights inside region
" Have a way to add more CHECK_PREFIX types
" creat a comment_prefix region?

" TODO: FileCheck comments!!

" Syntax-highlight FileCheck directives. We don't include the comment, as we
" can't predict what is before the directive
let s:filecheck_directive_labels_regex = '\v('.s:prefixes()->join('|').')'
let s:filecheck_directive_suffix_regex = '(-(COUNT-[0-9]+|NEXT|SAME|NOT|DAG|LABEL|EMPTY|(DAG|NEXT|SAME|EMPTY)-NOT|NOT-(DAG|NEXT|SAME|EMPTY)))?'
let s:filecheck_directive_header_regex = s:filecheck_directive_labels_regex.s:filecheck_directive_suffix_regex

" whole-directive regex. All other groups will be nested inside this one (but
" disallow nesting
exe "syn region filecheckDirective keepend excludenl matchgroup=Constant"
  \ "start=/".s:filecheck_directive_header_regex.":/rs=e-1"
  \ "end=/$/"
  \ "display contained oneline"
  "\ 'display contained containedin=cComment,cCommentL,llvmComment oneline'
"exe 'syn match filecheckDirectiveHeader' '/'s:filecheck_directive_header_regex.':/me=e-1' 'contained containedin=filecheckDirective'
syn cluster cCommentGroup add=filecheckDirective

" Allows us to use the Number group to highlight the counts
syn match filecheckCount "COUNT-\zs\d\+\ze:" contained containedin=filecheckDirective


" Regions have delimiters with the Delimiter group so we don't call the user's
" attention to them, just their contents.
" No nesting of {{}} possible
syn region filecheckRegexp keepend matchgroup=Delimiter start="{{" end="}}" contained containedin=filecheckDirective oneline

" region for setting/using variables
" Make sure we don't have a # following start, as that's a numeric
" substitution and handled specially
syn region filecheckSubst keepend matchgroup=Delimiter start="\[\[[^#@]"rs=e-1 end="]]" contained containedin=filecheckDirective oneline
syn region filecheckSubstNumeric keepend matchgroup=Delimiter start="\[\[#"rs=e-1 end="]]" contained containedin=filecheckDirective oneline

" Legacy substitutions for: [[@LINE]], [[@LINE+<offset>]], [[@LINE-<offset>]]
" create a region so we can highlight it with the rules below
syn match filecheckSubstLegacy /\[\[@LINE\%([+-]\d\+\)\?]]/ms=s+2,me=e-2 contained containedin=filecheckDirective

" non-assignment numeric expressions
syn match  filecheckSubstNumericExpr /\%(\[\[#\%(%\h,\)\?\|:\)\@<=[^:]*/ contained containedin=filecheckSubstNumeric
" assignment + expr for checking
syn match  filecheckSubstNumericAssignment /\h\w*:/ contained containedin=filecheckSubstNumeric nextgroup=filecheckSubstNumericExpr

" highlight fmt, variable names, operators, and numbers inside a numeric substitution
syn match  filecheckSubstNumericFmt /#\%(%\h,\)\?/ contained containedin=filecheckSubstNumeric nextgroup=filecheckSubstNumericAssignment,filecheckSubstNumericExpr
syn match  filecheckSubstNumericIdentifier /\(\h\w\+\|@LINE\)/ contained containedin=filecheckSubstNumericExpr,filecheckSubstNumericAssignment,filecheckSubstLegacy
syn match  filecheckSubstNumericExprNumber /\%(0x\x\+\|0\o\+\|\d\+\|\)/ contained containedin=filecheckSubstNumericExpr,filecheckSubstLegacy
syn match  filecheckSubstNumericExprOperator /[+-]/ contained containedin=filecheckSubstNumericExpr,filecheckSubstLegacy

" FIXME: cCppParen and cCppBracket have contains=ALLBUT,@cParenGroup,... which would make
" them able to contain a match/region which we meant to only have inside
" filecheckDirective. Let's add to that group so we don't match outside of
" comments. Unsure how to improve on this...
syn cluster cParenGroup add=filecheck.*

if version >= 508 || !exists("did_c_syn_inits")
  if version < 508
    let did_c_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    " override for now
    command -nargs=+ HiLink hi link <args>
    "command -nargs=+ HiLink hi def link <args>
  endif

  HiLink filecheckDirective Normal
  HiLink filecheckDirectiveHeader Constant
  HiLink filecheckCount Number
  HiLink filecheckSubst Special
  HiLink filecheckSubstNumeric PreProc
  HiLink filecheckSubstNumericFmt String
  HiLink filecheckSubstNumericAssignment Operator
  HiLink filecheckSubstNumericIdentifier Identifier
  HiLink filecheckSubstNumericExpr Statement
  HiLink filecheckSubstNumericExprOperator Operator
  HiLink filecheckSubstNumericExprNumber Number
  HiLink filecheckRegexp String

  delcommand HiLink
endif

if !exists('b:current_syntax')
  let b:current_syntax = "filecheck"
else
  let b:current_syntax = b:current_syntax.'.filecheck'
endif

unlet s:filecheck_directive_labels_regex
unlet s:filecheck_directive_suffix_regex
unlet s:filecheck_directive_header_regex
