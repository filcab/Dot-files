" Enable spelling in LaTeX files
setlocal spell spelllang=en_us iskeyword+=: " So fig:figure gets completion support

let g:tex_flavor = get(g:, 'tex_flavor', 'latex')    " LaTeX is the default flavor (not plain TeX)
let g:tex_mapleader = get(g:, 'tex_mapleader', ',')     " Leader character for LaTeX plugin
let g:Tex_DefaultTargetFormat = get(g:, 'Tex_DefaultTargetFormat', 'pdf')
let g:Tex_MultipleCompileFormats = get(g:, 'Tex_MultipleCompileFormats, 'pdf')

let g:Tex_CompileRule_dvi = get(g:, 'Tex_CompileRule_dvi', 'latex --interaction=nonstopmode $*')
let g:Tex_CompileRule_ps = get(g:, 'Tex_CompileRule_ps', 'dvips -Pwww -o $*.ps $*.dvi')
let g:Tex_CompileRule_pspdf = get(g:, 'Tex_CompileRule_pspdf', 'ps2pdf $*.ps')
let g:Tex_CompileRule_dvipdf = get(g:, 'Tex_CompileRule_dvipdf', 'dvipdfm $*.dvi')
let g:Tex_CompileRule_pdf = get(g:, 'Tex_CompileRule_pdf', 'xelatex -synctex=1 --interaction=nonstopmode $*')

let g:Tex_ViewRule_dvi = get(g:, 'Tex_ViewRule_dvi', 'texniscope')
let g:Tex_ViewRule_ps = get(g:, 'Tex_ViewRule_ps', 'Preview')
let g:Tex_ViewRule_pdf = get(g:, 'Tex_ViewRule_pdf', 'Skim')

let g:Tex_FormatDependency_ps  = get(g:, 'Tex_FormatDependency_ps', 'dvi,ps')
let g:Tex_FormatDependency_pspdf = get(g:, 'Tex_FormatDependency_pspdf', 'dvi,ps,pspdf')
let g:Tex_FormatDependency_dvipdf = get(g:, 'Tex_FormatDependency_dvipdf', 'dvi,dvipdf')

let b:undo_ftplugin .= '|setlocal spell< spelllang< iskeyword<'
