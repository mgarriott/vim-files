" Gui options
set guioptions=-tTmrR
set guioptions=+c
set guifont=Ubuntu\ Mono\ 13
set background=light
color solarized

if has("autocmd")
  function! s:AdjustLines()
    if &lines == 48
      set lines+=1
    endif
  endfunction

  augroup gui_autocmds
    au!

    " Having a problem with gvim not properly setting the lines to
    " occupy the fullscreen. This should fix that problem.
    " autocmd GUIEnter * call s:AdjustLines()

    autocmd BufWritePost .gvimrc,gvimrc source $MYGVIMRC
  augroup END
endif

noremap <leader>g :tabedit $MYGVIMRC<cr>

command! FontSwap call s:font_swap()
