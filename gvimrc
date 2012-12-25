" Gui options
set guioptions=-tTmrR
set guioptions=+c

if has("ruby")
  ruby VIM::command('let s:rand = ' + rand(3).to_s)
  if s:rand == '0'
    set guifont=Monaco\ Regular\ 12
  elseif s:rand == '1'
    set guifont=DejaVu\ Sans\ Mono\ 13
  else
    set guifont=Inconsolata\ Medium\ 15
  endif
endif
