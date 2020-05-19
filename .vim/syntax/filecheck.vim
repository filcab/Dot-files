" FileCheck syntax file
" Language:   llvm, cpp
" Maintainer: The LLVM team, http://llvm.org/
" Version:      $Revision$

"let s:verb = &verbose
"try
"set verbose=15

" If we've been loaded, don't redefine the functions
if !get(g:, "filecheck_syntax_loaded", v:false)
  " Set default values, user can override if needed
  let g:FileCheckPrefixes = get(g:, 'filecheck_prefixes', ["CHECK"])
  let g:FileCheckComments = get(g:, 'filecheck_comments', ["COM", "RUN"])

  function! FileCheckAddPrefixes(...) abort
    for arg in a:000
      g:FileCheckPrefixes->add(arg)
    endfor
  endfunction
  function! FileCheckAddComments(...) abort
    for arg in a:000
      g:FileCheckComments->add(arg)
    endfor
  endfunction

  let g:filecheck_syntax_loaded = v:true
endif

if version < 600
  syntax clear
elseif exists('b:current_syntax') && b:current_syntax =~ 'filecheck'
  let &verbose=s:verb
  finish
endif

syn case match

" Need to:
" create region for {CHECK_PREFIX}: .*
"   create highlights inside region
" Have a way to add more CHECK_PREFIX types
" creat a comment_prefix region?

" Syntax-highlight FileCheck directives. We don't include the comment, as we
" can't predict what is before the directive
let s:filecheck_directive_regex = '\v('.g:FileCheckPrefixes->join('|').')'
let s:filecheck_directive_suffix_regex = '(-(COUNT-[0-9]+|NEXT|SAME|NOT|DAG|LABEL|EMPTY|(DAG|NEXT|SAME|EMPTY)-NOT|NOT-(DAG|NEXT|SAME|EMPTY)))?:'

" Allows us to use the Number group to highlight the counts
syn match filecheckCount "COUNT-\zs\d\+\ze" contained containedin=filecheckDirective

" Regions have delimiters with the Delimiter group so we don't call the user's
" attention to them, just their contents.
" No nesting of {{}} possible
syn region filecheckRegexp matchgroup=Delimiter start="{{" end="}}" contained containedin=filecheckDirective
" region for setting/using variables
syn region filecheckVar matchgroup=Delimiter start="\[\[" end="]]" contained containedin=filecheckDirective

syn match filecheckVarName /\[\[\#\?zs[^:]\ze/ contained containedin=filecheckVar
syn match filecheckVarValue /:\zs.*\ze/ contained containedin=filecheckVar
syn match filecheckVarNumeric /\[\[\zs#\ze/ contained containedin=filecheckVar

" whole-directive regex. All other groups will be nested inside this one
exe "syn region filecheckDirective keepend"
 \ "start=/".s:filecheck_directive_regex.s:filecheck_directive_suffix_regex.".*$/"
 \ "end=/$/"
 \ "contained containedin=cComment,cCommentL,llvmComment contains=filecheck.* oneline"


if version >= 508 || !exists("did_c_syn_inits")
  if version < 508
    let did_c_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink filecheckDirective SpecialComment
  HiLink filecheckCount Number
  HiLink filecheckVar Define
  HiLink filecheckVarName Identifier
  HiLink filecheckVarValue Special
  HiLink filecheckVarNumeric SpecialChar
  HiLink filecheckRegexp String

  delcommand HiLink
endif

if !exists('b:current_syntax')
  let b:current_syntax = "filecheck"
else
  let b:current_syntax = b:current_syntax.'.filecheck'
endif

"finally
"  let &verbose=s:verb
"endtry
