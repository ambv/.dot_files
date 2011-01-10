" Vim Python documentation invoker.
"
" Version:  1.0
" Author: Łukasz Langa <lukasz@langa.pl>

" don't load twice
if exists('g:loaded_python_doc')
  finish
endif

if !exists('g:embedded_python_version') || g:embedded_python_version < 240 || g:embedded_python_version > 299
  "echo "This plugin requires Python 2.4+ (not 3.x though)."
  let g:loaded_python_doc = "ERROR"
  finish
else
  let g:loaded_python_doc = "py1.0"
endif

python << endpython
import os, sys, vim
path = "/ftplugin/python/python_doc.py"
prefix = "~/.vim"
if sys.platform in ('win32',):
  path = path.replace('/', '\\')
  prefix = r"C:\Tools\Vim\vimfiles"
vim.command("pyfile %s%s" % (prefix, path))
endpython

command! -nargs=* Pydoc :py PyDocSearch(<q-args>)

nmap ,p :py PyDocSearch(current_buffer=True)<CR>
