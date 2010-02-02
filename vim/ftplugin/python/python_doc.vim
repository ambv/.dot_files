" Vim Python documentation invoker.
"
" Version:  1.0
" Author: Łukasz Langa <lukasz@langa.pl>

if v:version < 700 || !has('python')
    echo "This script requires vim7.0+ with Python support." 
    finish 
endif

" don't load twice
if exists('g:loaded_python_doc')
  finish
endif
let b:loaded_python_doc = "py1.0"

pyfile ~/.vim/ftplugin/python/python_doc.py

command! -nargs=* Pydoc :py PyDocSearch(<q-args>)

nmap ,p :py PyDocSearch(current_buffer=True)<CR>
