autocmd!

syntax on

if has('folding')
  set foldlevelstart=999 foldopen=all "foldclose=all
  nnoremap <silent> <Space> @=(foldlevel('.')?'za':'l')<CR>
  vnoremap <Space> zf
endif

set history=250
set wildmode=list:longest,full
set shortmess+=r
set showmode
set showcmd

set rulerformat=%30(%=%m%r\ %b\ 0x%B\ \ %l,%c%V\ %P%)

set mouse=a

set nomodeline

"set nowrap
set shiftwidth=2
set shiftround
set expandtab
set autoindent

set number
filetype on
autocmd BufNewFile,BufRead *.txt set filetype=human
autocmd FileType mail,human set formatoptions+=t textwidth=72
autocmd FileType c set formatoptions+=ro
autocmd FileType perl set smartindent
autocmd FileType css set smartindent
autocmd FileType html set formatoptions+=tl
autocmd FileType html,css set noexpandtab tabstop=2
autocmd FileType make set noexpandtab shiftwidth=8

fun! Python_init()
  set tabstop=4 shiftwidth=4 smarttab expandtab
  set softtabstop=4 autoindent smartindent
  set cinwords=if,elif,else,for,while,try,except,finally,def,class
  set backspace=indent,eol,start isk+=.,( complete+=k~/.vim/pydiction
  set nowrap guioptions+=b
endfun
autocmd FileType python call Python_init()

set clipboard+=unnamed
set ruler
set wildmenu
filetype plugin indent on

set ignorecase
set smartcase
set incsearch
set gdefault

set whichwrap=h,l,~,[,]

nnoremap <F6> <C-W>w
nnoremap <S-F6> <C-W>W

set matchpairs+=<:>

vnoremap <C-T> >
vnoremap <C-D> <LT>
vmap <Tab> <C-T>
vmap <S-Tab> <C-D>

noremap Y y$

fun Paste_toggle(insert_mode)
  if &paste || (a:insert_mode != 0 && !&number)
    set nopaste
    set number
    set mouse=a 
  else
    set paste
    set nonumber
    set mouse=
  endif
  "set paste? number? mouse?
endfun

command PasteToggle :call Paste_toggle(0)
nmap <F4> :call Paste_toggle(0)<CR>
imap <F4> <C-O>:call Paste_toggle(1)<CR>
set pastetoggle=<F4>

nnoremap \tf :if &fo =~ 't' <Bar> set fo-=t <Bar> else <Bar> set fo+=t <Bar>
      \ endif <Bar> set fo?<CR>
nmap <F3> \tf
imap <F3> <C-O>\tf

nnoremap \tl :set invlist list?<CR>
nmap <F2> \tl

nnoremap \th :set invhls hls?<CR>
nmap <F1> \th
imap <F1> <C-O>\th

set backspace=eol,start,indent

inoremap <Tab> <C-T>
inoremap <S-Tab> <C-D>

set winminheight=0      " Allow windows to get fully squashed

"colorscheme delek
set cursorline

map <F11> :call SwitchToISO()<CR>
func! SwitchToISO()
  e! ++enc=iso-8859-2
endfunc

map <F12> :call SwitchToUTF8()<CR>
func! SwitchToUTF8()
  e! ++enc=utf-8
endfunc

set formatoptions-=tl
set textwidth=999

set so=10
set hidden

"Uncomment to get free cursor movement.
"set virtualedit=all

autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" |  endif 
