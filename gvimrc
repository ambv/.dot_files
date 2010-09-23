if &background == "dark"
    hi normal guifg=#eeeeee guibg=black
    hi cursor guifg=#d7ff00
    hi lcursor guifg=#00cd00
    if has("gui_macvim")
      set transp=8
    endif
endif

if has("gui_macvim")
  set guifont=Terminus:h14
else
  set guifont=Lucida\ Console
endif
set go=cegt
set cursorcolumn
