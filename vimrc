" Vim RC
"
" Maintainer: Łukasz Langa <lukasz@langa.pl>

" Bootstrap settings:
" - reset previously set environmental settings
" - don't allow specific files to override settings from this file
"
autocmd!
set nomodeline



"
" UI configuration
"
colorscheme ambv
syntax on "highlight syntax with specific group for bad whitespace:
highlight BadWhitespace ctermbg=red guibg=red
set history=250 "number of commands to remember in the command line
set wildmenu wildmode=full "show a list of possible values on Tab
set showmode "show what mode you're in (Insert, Replace, Visual, etc.)
set shortmess=aoO "abbreviate status line but don't truncate messages
set showcmd "show combo command as you type it in the bottom right corner
set ruler laststatus=2 "show rulers for buffers and the status line even if there's only 1 file
set rulerformat=%30(%=\ %b\ 0x%B\ \ %l:%c\ %P%) "as the name says
set mouse=a "use the mouse wherever possible
set title "change the terminal title according to the currently active buffer
set number "always show line numbers unless otherwise specified
set clipboard+=unnamed "the same clipboard is used for Visual mode
set ignorecase smartcase "when searching, match case only when at least one char is upper
set incsearch "start searching while typing
set gdefault "automatically add /g to searches; actually specifying /g now toggles the value
set backspace=eol,start,indent "make backspace work between lines and with indentation
set whichwrap=<,>,~,[,] "allow crossing line borders with cursors in every mode
set winminheight=0 "Allow windows to get fully squashed
set scrolloff=10 "start scrolling 10 lines before the end of the buffer
set cursorline "highlight current line
"set cursorcolumn "highlight current column; turned off because it works slow
"set virtualedit=all "cursor can move anywhere (even beyond text boundaries)



"
" Default formatting and editing options
"
set shiftwidth=2 tabstop=2 softtabstop=2 "by default, Tab moves by 2 spaces
set shiftround "tabbing and detabbing also uses shiftwidth
set expandtab "use Space instead of Tab 
set autoindent "keep current indent state when starting a new line
set matchpairs+=(:),{:},[:],<:> "join these pairs of characters; useful for highlighting
                                "and jumping between with %
set wrap textwidth=0 formatoptions=l "wrap text by default but don't insert additional
                                     "new lines on text input
"set hidden "don't destroy buffers that are hidden; think twice before using :q! or :qa!



"
" Filetype specific formatting and editing options
"
filetype on
filetype plugin indent on

function! Python_init()
  set shiftwidth=4 tabstop=4 softtabstop=4 "standard PEP8 Tab length
  set smartindent "use the keywords below to add additional indentation
  set cinwords=if,elif,else,for,while,try,except,finally,def,class
  "smartindent is OK but don't move # comments to the first column please:
  inoremap # X#
  set formatoptions=cq12 textwidth=80 "wrap lines longer than 80 characters
  set complete+=k~/.vim/pydiction "use auto-completion from the specified dictionary
  set nowrap "don't wrap source code, it's evil
  set noignorecase nosmartcase "avoid corrupting source code on search/replace operations
  "set smarttab "I don't really know what this does when sw == ts == sts
  "set isk+=.,(
endfunction

autocmd BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
autocmd BufNewFile,BufRead *.txt set filetype=human
autocmd BufNewFile,BufRead *.json set filetype=javascript
autocmd FileType gitcommit,human,mail,rst set formatoptions=1aconrtq textwidth=80 "fo+=w textwidth=72
autocmd FileType c set formatoptions+=ro
autocmd FileType perl set smartindent
autocmd FileType css set smartindent
autocmd FileType html set formatoptions+=tl1 textwidth=80
autocmd FileType make set noexpandtab shiftwidth=8 tabstop=8 softtabstop=8
autocmd FileType python call Python_init()
autocmd FileType pyrex call Python_init()
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" |  endif "return to the last edited line in opened files:
autocmd BufReadCmd *.egg,*.odp,*.ods,*.odt,*.jar,*.xmap,*.xmind,*.xpi call zip#Browse(expand("<amatch>"))
autocmd InsertLeave * redraw!

"
" Folding; closed by default because it caused confusion in the long run.
"
if has('folding')
  set foldlevelstart=999 foldopen=all "foldclose=all
  nnoremap <silent> <Space> @=(foldlevel('.')?'za':'l')<CR>
  vnoremap <Space> zf
endif



"
" Keyboard shortcuts
" 

"Tab/Shift-Tab controls indentation also in Visual and Insert mode
vnoremap <C-T> >
vnoremap <C-D> <LT>
vmap <Tab> <C-T>
vmap <S-Tab> <C-D>
inoremap <Tab> <C-T>
inoremap <S-Tab> <C-D>

"Y works like D does
noremap Y y$

nnoremap tt :NERDTreeToggle<CR>

"F1 toggles highlighting search results
nnoremap \th :set invhls hls?<CR>
nmap <F1> \th
imap <F1> <C-O>\th

"F2 toggles showing invisible characters
nnoremap \tl :set invlist list?<CR>
nmap <F2> \tl

"F3 toggles autowrapping on Insert
nnoremap \tf :if &fo =~ 't' <Bar> set fo-=t <Bar> else <Bar> set fo+=t <Bar>
      \ endif <Bar> set fo?<CR>
nmap <F3> \tf
imap <F3> <C-O>\tf

"F4 handles paste toggling; works perfectly in Normal mode, Insert mode requires
"two keystrokes to leave paste mode entirely
nmap <F4> :call Paste_toggle(0)<CR>
imap <F4> <C-O>:call Paste_toggle(1)<CR>
set pastetoggle=<F4>
function Paste_toggle(insert_mode)
  """ toggling between paste mode and normal mode; includes removing
  """ mouse support and numbering (for terminal cut&paste purposes)
  if &paste || (a:insert_mode != 0 && !&number)
    set nopaste number cursorline mouse=a 
  else
    set paste nonumber nocursorline mouse=
  endif
endfunction
command PasteToggle :call Paste_toggle(0)

"F5 toggles taglist
nnoremap <F5> :TlistToggle<CR>
inoremap <F5> <C-O>:TlistToggle<CR>

"F6 toggles between windows
nnoremap <F6> <C-W>w
nnoremap <S-F6> <C-W>W

"F11 forces file reload in ISO-8859-2 charset
map <F11> :call SwitchToISO()<CR>
func! SwitchToISO()
  e! ++enc=iso-8859-2
endfunc

"F12 forces file reload in UTF-8 charset
map <F12> :call SwitchToUTF8()<CR>
func! SwitchToUTF8()
  e! ++enc=utf-8
endfunc



"
" Specific plug-in configuration
"
let python_highlight_indent_errors=1
let python_highlight_space_errors=1
let python_highlight_string_formatting=1
let python_highlight_string_format=1
let python_highlight_string_templates=1
let python_highlight_doctests=1
let python_slow_sync=1

let NERDTreeIgnore=['\~$', '^\~', '\.swp$', '\$$', 
      \ '\.pyc$', '\.pyo$', '\.pyd$', 
      \ '\.class$', '\.bak$', '\.bin$', 
      \ '\.jpg$', '\.gif$', '\.png$', '\.bmp$',
      \ '\.mo$']

let Tlist_Use_Right_Window=1
"let Tlist_Use_Horiz_Window=1
let Tlist_Compact_Format=1

let snips_author='Łukasz Langa'
