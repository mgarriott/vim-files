" Gui options
set guioptions=-tTmrR
set guioptions=+c

let s:rand = localtime() % 2

if s:rand == 0
  set guifont=Monaco\ Regular\ 13
else
  set guifont=Inconsolata\ Medium\ 15
endif

" Having a problem with gvim not properly setting the lines to
" be fullscreen. This should fix that problem.
if has("autocmd")
  function! s:AdjustLines()
    if &lines == 48
      set lines+=3
    endif
  endfunction

  augroup gui_autocmds
    au!
    autocmd GUIEnter * call s:AdjustLines()
  augroup END
endif
