" Vim color file based on David Schweikert's "delek"
" Last Change:	2010 Feb 2

set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "ambv"

if version >= 700
  hi CursorLine ctermbg=233
  hi CursorColumn ctermbg=233
endif

" Normal should come first
" hi Normal
" hi Cursor
" hi lCursor

" Note: we never set 'term' because the defaults for B&W terminals are OK
hi DiffAdd    ctermbg=234
hi DiffChange ctermbg=235
"hi DiffDelete ctermbg=52
hi DiffDelete ctermfg=52 ctermbg=0
hi DiffText   ctermbg=238 ctermfg=White cterm=NONE
hi Directory  ctermfg=DarkBlue
hi ErrorMsg   ctermfg=White	   ctermbg=DarkRed
hi FoldColumn ctermfg=White    ctermbg=238
hi Folded     ctermbg=Grey	   ctermfg=Black
hi IncSearch  cterm=reverse
hi LineNr     ctermfg=242	
hi ModeMsg    cterm=bold
hi MoreMsg    ctermfg=DarkGreen
hi NonText    ctermfg=237
hi Pmenu      ctermfg=White    ctermbg=240
hi PmenuSel   ctermfg=Black	   ctermbg=250
hi Question   ctermfg=DarkGreen
hi Search     ctermfg=NONE	   ctermbg=DarkBlue
hi SpecialKey ctermfg=DarkBlue
hi StatusLine 	   ctermfg=240 ctermbg=white
hi StatusLineNC	   ctermfg=238 ctermbg=253
hi Title      ctermfg=DarkMagenta
hi VertSplit  ctermfg=238
hi Visual     ctermbg=235
hi VisualNOS  cterm=underline,bold
hi WarningMsg ctermfg=DarkRed
hi WildMenu   ctermfg=Black	   ctermbg=250

" syntax highlighting
hi Comment    cterm=NONE ctermfg=DarkRed 
hi Constant   cterm=NONE ctermfg=DarkGreen
hi Identifier cterm=NONE ctermfg=DarkCyan
hi PreProc    cterm=NONE ctermfg=DarkMagenta
hi Special    cterm=NONE ctermfg=60
hi Statement  cterm=bold ctermfg=Blue
hi Type	      cterm=NONE ctermfg=Blue

" vim: sw=2
