" Gui options
set guioptions=-tTmrR
set guioptions=+c

let s:rand = localtime() % 2

if s:rand == 0
  set guifont=Monaco\ Regular\ 13
else
  set guifont=Inconsolata\ Medium\ 15
endif
