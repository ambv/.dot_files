" Vim Python filetype plugin for typing `self.` by pressing `.`
"
" Version:  1.0.3
" Website:  http://github.com/narfdotpl/selfdot.vim
" License:  public domain <http://unlicense.org/>
" Author:   Maciej Konieczny <hello@narf.pl>


" don't load twice
if exists('b:loaded_selfdot')
    finish
endif
let b:loaded_selfdot = 1

" make line continuation work with `:set compatible`
let s:save_cpo = &cpo
set cpo&vim


let s:PREFIXES = [' ', "\t", '(', '[', '{', '=', '>', '<', '+', '-', '*', '/',
                \ '%', '&', '|', '~', ',', ';', ':', '@', '`', '#']

if !exists('*s:DotOrSelfdot')
    function s:DotOrSelfdot()
        let prev_char = getline('.')[col('.') - 2]

        for prefix in s:PREFIXES
            if prev_char == prefix
                return 'self.'
            endif
        endfor

        return '.'
    endfunction
endif

inoremap <buffer> <expr> . <SID>DotOrSelfdot()


" restore cpoptions (`:set compatible` stuff)
let &cpo = s:save_cpo
