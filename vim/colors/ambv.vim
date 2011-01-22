" Vim color file based on David Schweikert's "delek"
" Last Change:	2010 Feb 2

set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "ambv"

if version >= 700
  hi CursorLine ctermbg=233 guibg=#1c1c1c gui=underline
  hi CursorColumn ctermbg=233 guibg=#1c1c1c
endif

" Normal should come first
" hi Normal
" hi Cursor
" hi lCursor

" Note: we never set 'term' because the defaults for B&W terminals are OK
hi DiffAdd    ctermbg=234 guibg=#1c1c1c
hi DiffChange ctermbg=235 guibg=#262626
"hi DiffDelete ctermbg=52
hi DiffDelete ctermfg=52 ctermbg=0 guifg=#5f0000 guibg=#000000
hi DiffText   ctermbg=238 ctermfg=White cterm=NONE guibg=#444444 guifg=#ffffff gui=NONE
hi Directory  ctermfg=DarkBlue guifg=#2222ee
hi ErrorMsg   ctermfg=White	   ctermbg=DarkRed gui=BOLD guifg=#ffffff guibg=#cd2222
hi FoldColumn ctermfg=White    ctermbg=238 guifg=#ffffff guibg=#444444
hi Folded     ctermbg=Grey	   ctermfg=Black guibg=#7f7f7f guifg=#000000
hi IncSearch  cterm=reverse gui=reverse
hi LineNr     ctermfg=242	guifg=#7c7c7c
hi ModeMsg    cterm=bold gui=BOLD
hi MoreMsg    ctermfg=DarkGreen guifg=#22cd22
hi NonText    ctermfg=237 guifg=#3a3a3a
hi Pmenu      ctermfg=White    ctermbg=240 guifg=#ffffff guibg=#585858
hi PmenuSel   ctermfg=Black	   ctermbg=250 guifg=#000000 guibg=#bcbcbc
hi Question   ctermfg=DarkGreen guifg=#22cd22
hi Search     ctermfg=NONE	   ctermbg=DarkBlue guifg=NONE guibg=#2222ee
hi SpecialKey ctermfg=DarkBlue guifg=#2222ee
hi StatusLine 	   ctermfg=240 ctermbg=white guifg=#585858 guibg=#ffffff
hi StatusLineNC	   ctermfg=238 ctermbg=253 guifg=#444444 guibg=#dadada
hi Title      ctermfg=DarkMagenta guifg=#cd22cd
hi VertSplit  ctermfg=238 guifg=#444444
hi Visual     ctermbg=235 guibg=#262626
hi VisualNOS  cterm=underline,bold gui=underline,bold
hi WarningMsg ctermfg=DarkRed guifg=#cd2222
hi WildMenu   ctermfg=Black	   ctermbg=250 guifg=#000000 guibg=#bcbcbc

" syntax highlighting
hi Comment    cterm=NONE ctermfg=DarkRed gui=NONE guifg=#cd2222
hi Constant   cterm=NONE ctermfg=DarkGreen gui=NONE guifg=#22cd22
hi Identifier cterm=NONE ctermfg=DarkCyan gui=BOLD guifg=#22cdcd
hi PreProc    cterm=NONE ctermfg=DarkMagenta gui=NONE guifg=#cd22cd
hi Special    cterm=NONE ctermfg=60 gui=NONE guifg=#5f5f87
hi Statement  cterm=bold ctermfg=Blue gui=BOLD guifg=#7c7cff
hi Type	      cterm=NONE ctermfg=Blue gui=BOLD guifg=#7c7cff

highlight OverLength ctermbg=17 ctermfg=white guibg=#000040
highlight ExtraWhitespace ctermbg=17 guibg=#000040
