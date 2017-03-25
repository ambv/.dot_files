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
syntax on "highlight syntax
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
set sidescroll=10 "start scrolling 10 columns before the end of the buffer
set showmatch "flash matching parent when typing
set cursorline "highlight current line
set cursorcolumn "highlight current column
set noerrorbells "shut up about reaching buffer boundary, etc.
set ttyfast "fast terminal connection, more bandwidth but better redrawing performance
set undolevels=1000
set viminfo='50,"50
"set noswapfile
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
set hidden "don't destroy buffers that are hidden; think twice before using :q! or :qa!



"
" Filetype specific formatting and editing options
"
filetype on
filetype plugin indent on

func! Python_init()
  setlocal shiftwidth=4 tabstop=4 softtabstop=4 "standard PEP8 Tab length
  setlocal smartindent "use the keywords below to add additional indentation
  setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class
  "smartindent is OK but don't move # comments to the first column please:
  inoremap # X#
  setlocal formatoptions=cq12 textwidth=79 "wrap lines longer than 79 characters
  setlocal complete+=k~/.vim/pydiction "use auto-completion from the specified dictionary
  setlocal nowrap "don't wrap source code, it's evil
  setlocal noignorecase nosmartcase "avoid corrupting source code on search/replace operations
  "setlocal smarttab "I don't really know what this does when sw == ts == sts
  "setlocal isk+=.,(
  match ExtraWhitespace /\s\+\%#\@<!$/
  match OverLength /\%80v.\+/
  "setlocal foldcolumn=4 "No confusion.
  "IndentLinesToggle on
endfunc

func! JS_init()
  setlocal shiftwidth=2 tabstop=2 softtabstop=2 "standard PEP8 Tab length
  setlocal smartindent "use the keywords below to add additional indentation
  setlocal formatoptions=cqtro textwidth=79 "wrap lines longer than 79 characters
  setlocal noignorecase nosmartcase "avoid corrupting source code on search/replace operations
endfunc

func! HTML_init()
  setlocal shiftwidth=2 tabstop=2 softtabstop=2 "by default, Tab moves by 2 spaces
  setlocal wrap
  setlocal formatoptions-=t
  "setlocal formatoptions+=tl1 textwidth=80
endfunc

func! PHP_init()
  setlocal iskeyword+=$
  setlocal includeexpr=substitute(v:fname,'^/','','')
endfunc

func! REST_init()
  setlocal formatoptions=1aconrtq textwidth=72
  setlocal wrap
  match ExtraWhitespace /\s\+\%#\@<!$/
endfunc

autocmd BufNewFile,BufRead *.cabal setlocal filetype=cabal
autocmd BufNewFile,BufRead *.cconf setlocal filetype=python
autocmd BufNewFile,BufRead *.cinc setlocal filetype=python
autocmd BufNewFile,BufRead *.ctest setlocal filetype=python
autocmd BufNewFile,BufRead *.hsc setlocal filetype=haskell
autocmd BufNewFile,BufRead *.html setlocal filetype=htmldjango
autocmd BufNewFile,BufRead *.json setlocal filetype=javascript
autocmd BufNewFile,BufRead *.phpt setlocal filetype=php
autocmd BufNewFile,BufRead *.sieve setlocal filetype=sieve
autocmd BufNewFile,BufRead *.smcprops setlocal filetype=python
autocmd BufNewFile,BufRead *.thrift setlocal filetype=thrift
autocmd BufNewFile,BufRead *.thrift-cvalidator setlocal filetype=python
autocmd BufNewFile,BufRead *.tw setlocal filetype=python
autocmd BufNewFile,BufRead *.txt setlocal filetype=human
autocmd BufNewFile,BufRead README setlocal filetype=human
autocmd FileType gitcommit,human,mail setlocal formatoptions=1aconrtq textwidth=79
autocmd FileType rst call REST_init()
autocmd FileType c setlocal formatoptions+=ro
autocmd FileType perl setlocal smartindent
autocmd FileType php call PHP_init()
autocmd FileType css setlocal smartindent
autocmd FileType html call HTML_init()
autocmd FileType htmldjango call HTML_init()
autocmd FileType make setlocal noexpandtab shiftwidth=8 tabstop=8 softtabstop=8
autocmd FileType python call Python_init()
autocmd FileType pyrex call Python_init()
" Kill trailing whitespace on save
autocmd FileType c,cabal,cpp,haskell,javascript,php,python,readme,rst,text
  \ autocmd BufWritePre <buffer>
  \ :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))
" autocmd FileType python autocmd BufWritePost <buffer> call Flake8()
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" |  endif "return to the last edited line in opened files:
autocmd BufReadCmd *.egg,*.odp,*.ods,*.odt,*.jar,*.xmap,*.xmind,*.xpi call zip#Browse(expand("<amatch>"))
autocmd InsertLeave * redraw!
if $SVN_COMMIT_TEMPLATE != ""
  autocmd BufNewFile,BufRead svn-commit.*tmp :0r $SVN_COMMIT_TEMPLATE
endif

"
" Folding; closed by default because it caused confusion in the long run.
"
if has('folding')
  set foldlevelstart=100 foldclose=all
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
func Paste_toggle(insert_mode)
  """ toggling between paste mode and normal mode; includes removing
  """ mouse support and numbering (for terminal cut&paste purposes)
  if &paste || (a:insert_mode != 0 && !&number)
    set nopaste number cursorline mouse=a 
  else
    set paste nonumber nocursorline mouse=
  endif
endfunc
command PasteToggle :call Paste_toggle(0)

func Underline(type)
  """ toggling between paste mode and normal mode; includes removing
  """ mouse support and numbering (for terminal cut&paste purposes)
  if &paste
    normal "tyy"tpv$
    if a:type == 1
      normal r="tyyk"tP
    elseif a:type == 2
      normal r-
    elseif a:type == 3
      normal r~
    endif
  else
    set paste nonumber nocursorline mouse=
    normal "tyy"tpv$
    if a:type == 1
      normal r="tyyk"tP
    elseif a:type == 2
      normal r-
    elseif a:type == 3
      normal r~
    endif
    set nopaste number cursorline mouse=a 
  endif
endfunc
nmap ,-1 :call Underline(1)<CR>
nmap ,-2 :call Underline(2)<CR>
nmap ,-3 :call Underline(3)<CR>

"Ctrl+q as Insert/Normal mode toggle
inoremap jj <ESC>

":W command to "sudo & write" if you forget to sudo first
"cmap W w !sudo tee % >/dev/null
"Turned off because mapped each "W" typed. Gotta come up with something better.

" bind "gb" to "git blame" for visual and normal mode.
:vmap gb :<C-U>!git blame % -L<C-R>=line("'<") <CR>,<C-R>=line("'>") <CR><CR>
:nmap gb :!git blame %<CR>

"
" Specific plug-in configuration
"
let python_highlight_builtins=1
let python_highlight_exceptions=1
let python_highlight_indent_errors=1
let python_highlight_space_errors=1
let python_highlight_string_formatting=1
let python_highlight_string_format=1
let python_highlight_string_templates=1
let python_highlight_doctests=1
let python_slow_sync=1

let snips_author='Łukasz Langa'

let bufExplorerFindActive=0
let bufExplorerShowRelativePath=1
"let bufExplorerSortBy="fullpath"

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ["flake8"]
let g:syntastic_python_flake8_exec = "flake8"
