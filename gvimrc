" Gui options
set guioptions=-tTmrR
set guioptions=+c

let s:rand = localtime() % 2

if s:rand == 0
  set guifont=Monaco\ Regular\ 13
else
  set guifont=Inconsolata\ Medium\ 15
endif

if has("autocmd")
  function! s:AdjustLines()
    if &lines == 48
      set lines+=3
    endif
  endfunction

  augroup gui_autocmds
    au!

    " Having a problem with gvim not properly setting the lines to
    " occupy the fullscreen. This should fix that problem.
    autocmd GUIEnter * call s:AdjustLines()

    autocmd BufWritePost .gvimrc,gvimrc source $MYGVIMRC
  augroup END
endif

noremap <leader>g :tabedit $MYGVIMRC<cr>
