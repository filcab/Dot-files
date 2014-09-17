""" Start of FilCab's stuff
" Setup up pathogen and only turn on filetype stuff afterwards
filetype off

call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on

" Automatically reload changed files
set autoread

"Auto-reload vimrc
autocmd! bufwritepost .vimrc source ~/.vimrc


" Allow some commands with the first letter(s) capitalized
if has("user_commands")
    command! -bang -nargs=? -complete=file E e<bang> <args>
    command! -bang -nargs=? -complete=file W w<bang> <args>
    command! -bang -nargs=? -complete=file Wq wq<bang> <args>
    command! -bang -nargs=? -complete=file WQ wq<bang> <args>
    command! -bang Wa wa<bang>
    command! -bang WA wa<bang>
    command! -bang Q q<bang>
    command! -bang QA qa<bang>
    command! -bang Qa qa<bang>
endif

" Per FreeBSD's security advice
set nomodeline

" completion (CTRL+N) options
set completeopt+=longest

" extend the $PATH variable with the vim scripts' dir
"let $PATH .= "~/.vim/bin"

" vim is the default editor for vim's subshells
let $EDITOR = "vim"

" make grep always print the filename (default: without the -H)
set grepprg=grep\ -nH\ $*\ /dev/null

" Make %% in the command line expand to the directory of the current file
cabbr <expr> %% expand('%:p:h')

" Make filename completion case-insensitive
if exists("&wildignorecase")
    set wildignorecase
endif

" LaTeX stuff
" enable spelling in LaTeX files
au BufRead,BufNewFile *.tex,*.bib  setlocal spell spelllang=en_us iskeyword+=: " So fig:figure gets completion support


let g:tex_flavor = 'latex'    " LaTeX is the default flavor (not plain TeX)
let g:tex_mapleader = ','     " Leader character for LaTeX plugin
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_MultipleCompileFormats = 'pdf'

let g:Tex_CompileRule_dvi = 'latex --interaction=nonstopmode $*'
let g:Tex_CompileRule_ps = 'dvips -Pwww -o $*.ps $*.dvi'
let g:Tex_CompileRule_pspdf = 'ps2pdf $*.ps'
let g:Tex_CompileRule_dvipdf = 'dvipdfm $*.dvi'
let g:Tex_CompileRule_pdf = 'xelatex -synctex=1 --interaction=nonstopmode $*'

let g:Tex_ViewRule_dvi = 'texniscope'
let g:Tex_ViewRule_ps = 'Preview'
let g:Tex_ViewRule_pdf = 'Skim'

let g:Tex_FormatDependency_ps  = 'dvi,ps'
let g:Tex_FormatDependency_pspdf = 'dvi,ps,pspdf'
let g:Tex_FormatDependency_dvipdf = 'dvi,dvipdf'

" Always show the status bar
set laststatus=2

" Default statusline:
set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P

" When in a git repo, tell us the current branch
let &statusline = '%{fugitive#statusline()} ' . &statusline

" Add highlighting for function definition in C++
function! EnhanceCppSyntax()
  syn match cppFuncDef "::\~\?\zs\h\w*\ze([^)]*\()\s*\(const\)\?\)\?$"
  hi def link cppFuncDef Special
endfunction

""" End of FilCab's stuff

" reset to vim-defaults
if &compatible          " only if not set before:
  set nocompatible      " use vim-defaults instead of vi-defaults (easier, more user friendly)
endif

" display settings
set background=dark     " enable for dark terminals
"set nowrap              " dont wrap lines
set textwidth=74
"set wrapmargin=4        " When wrapping, set up a margin
set scrolloff=2         " 2 lines above/below cursor when scrolling
set nonumber            " do not show line numbers
set showmatch           " show matching bracket (briefly jump)
set showmode            " show mode in status bar (insert/replace/...)
set showcmd             " show typed command in status bar
set ruler               " show cursor position in status bar
set title               " show file in titlebar

if has("wildmenu")
  set wildignore+=*.a,*.o
  set wildignore+=*.pyc
  set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
  set wildignore+=.DS_Store,.git,.hg,.svn
  set wildignore+=*.framework
  set wildignore+=*~,*.swp,*.tmp
  set wildmenu            " completion with menu
  set wildmode=longest:full " complete longest match and show menu
endif

" editor settings
set esckeys             " map missed escape sequences (enables keypad keys)
set ignorecase          " case insensitive searching
set smartcase           " but become case sensitive if you type uppercase characters
"set smartindent         " smart auto indenting
set smarttab            " smart tab handling for indenting
set magic               " change the way backslashes are used in search patterns
set bs=indent,eol,start " Allow backspacing over everything in insert mode
set backupdir=~/.vim/backup " Hide backups in the .vim directory

set tabstop=4           " number of spaces a tab counts for
set shiftwidth=2        " spaces for autoindents
set expandtab           " turn a tabs into spaces

" splitting settings
set splitbelow          " When splitting open the new file below or to the right
set splitright

" misc settings
set nospell             " Don't spell-check
"set fileformat=unix     " file mode is unix
set fileformats=unix,dos    " only detect unix file format, displays that ^M with dos files

set viminfo='20,\"500   " remember copy registers after quitting in the .viminfo file -- 20 jump links, regs up to 500 lines'
set hidden              " remember undo after quitting
set history=50          " keep 50 lines of command history

set mouse=v             " use mouse in visual mode (not normal,insert,command,help mode

let g:yankring_history_file = '.vim.yankring_history'


" color settings (if terminal/gui supports it)
if &t_Co > 2 || has("gui_running")
  syntax on               " enable colors
  set hlsearch            " highlight search (very useful!)
  set incsearch           " search incremently (search while typing)
  set guioptions-=T       " Don't show toolbar
  if has("gui_running")   " Only in a GUI
    "colorscheme ir_black  " A nice colorscheme I found online
    set background=dark
    colorscheme molokai
  endif
endif

" paste mode toggle (needed when using autoindent/smartindent)
map <F10> :set paste<CR>
map <F11> :set nopaste<CR>
imap <F10> <C-O>:set paste<CR>
imap <F11> <nop>
set pastetoggle=<F11>

" clang-format integration
map <C-I> :pyf ~/.vim/clang-format.py<CR>
imap <C-I> <ESC>:pyf ~/.vim/clang-format.py<CR>i

" file type specific settings
if has("autocmd")
  " For debugging
  "set verbose=9

  " change to directory of current file automatically
  "autocmd BufEnter * lcd %:p:h

  " Put these in an autocmd group, so that we can delete them easily.
  augroup mostfiles
    au BufReadPre,BufNewFile
    \ *.xsl,*.xml,*.css,*.html,*.js,*.php,*.sql,*.sh,*.conf,*.cc,*.cpp,*.h
    \  setlocal smartindent shiftwidth=2 softtabstop=2 expandtab
  augroup END

  augroup tex
    au BufReadPre,BufNewFile
    \ *.tex
    \ set wrap setlocal shiftwidth=2 softtabstop=2 expandtab
  augroup END

  augroup perl
    " reset (disable previous 'augroup perl' settings)
    au!  

    au BufReadPre,BufNewFile
    \ *.pl,*.pm
    \ setlocal formatoptions=croq smartindent shiftwidth=2 softtabstop=2 cindent cinkeys='0{,0},!^F,o,O,e' " tags=./tags,tags,~/devel/tags,~/devel/C
    " formatoption:
    "   t - wrap text using textwidth
    "   c - wrap comments using textwidth (and auto insert comment leader)
    "   r - auto insert comment leader when pressing <return> in insert mode
    "   o - auto insert comment leader when pressing 'o' or 'O'.
    "   q - allow formatting of comments with "gq"
    "   a - auto formatting for paragraphs
    "   n - auto wrap numbered lists
    "   
  augroup END

  augroup python
    au BufReadPre,BufNewFile *.py setlocal shiftwidth=4
  augroup END

  augroup filetype
    " LLVM stuff
    " sO:" -,mO:"  ,eO:"",:"
    au! BufRead,BufNewFile *.ll     set filetype=llvm iskeyword+=% comments=s0:\ -,m0:;,e0:;;,:;
    au! BufRead,BufNewFile *.td     set filetype=tablegen
    " SWIG
    au! BufRead,BufNewFile *.swig   set filetype=swig
  augroup END

  " Add highlighting for function definition in C++
  autocmd Syntax cpp call EnhanceCppSyntax()


  " Always jump to the last known cursor position. 
  " Don't do it when the position is invalid or when inside
  " an event handler (happens when dropping a file on gvim). 
  autocmd BufReadPost * 
    \ if line("'\"") > 0 && line("'\"") <= line("$") | 
    \   exe "normal g`\"" | 
    \ endif 

endif " has("autocmd")


" From http://vim.wikia.com/wiki/Auto_highlight_current_word_when_idle
" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.
nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=4000
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=500
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction

