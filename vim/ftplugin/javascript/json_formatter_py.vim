" json_formatter_py.vim
" Author: Łukasz Langa 
" Created:  Mon Feb 02 00:32:12 CET 2010
" Requires: Vim Ver7.0+ 
" Version:  1.0
"
" Documentation: 
"   This plugin validates and formats JSON files.
"
" History:
"  1.0:
"    - initial version

if v:version < 700 || !has('python')
    echo "This script requires vim7.0+ with Python support." 
    finish 
endif

if exists("g:load_json_formatter")
   finish
endif

let g:load_json_formatter = "py1.0"

pyfile ~/.vim/ftplugin/javascript/json_formatter.py

command! ReformatJSON :py ReformatJSON()

nmap ,= :ReformatJSON<CR>
vmap ,= :ReformatJSON<CR>
