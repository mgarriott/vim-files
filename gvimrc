" Gui options
set guioptions=-tTmrR
set guioptions=+c
set guifont=Source\ Code\ Pro\ 13
set background=light
color solarized

" Set font size to the provided size
function! s:setFontSize(size)
  let new_font = substitute(&gfn, '\d\+.\{-}$', a:size, '')
  let &gfn = new_font
endfunction

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
command! -nargs=1 FontSize call s:setFontSize(<f-args>)
