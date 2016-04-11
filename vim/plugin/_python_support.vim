" Vim Python support routines.
"
" Version:  1.0
" Author: Łukasz Langa <lukasz@langa.pl>

if exists('g:embedded_python_version')
  finish
endif

if v:version < 700 || !has('python3')
    echo ".dot_files require vim7.0+ with Python support." 
    finish 
endif

python3 << endpython
import os, sys, vim
vim.command("let g:embedded_python_version=%d" % (sys.version_info[0] * 100 + sys.version_info[1] * 10 + sys.version_info[2]))
endpython
