" Gui options
set guioptions=-tTmrR
set guioptions=+c

let s:rand = localtime() % 2

function! s:font_swap()
  let current_font = &guifont
  if current_font =~? 'Monaco'
    set guifont=Inconsolata\ Medium\ 15
  else
    set guifont=Monaco\ Regular\ 13
  endif

  " Swapping the font screws up this lines. Add one line to fix it.
  set lines+=1
endfunction

if has("autocmd")
  function! s:AdjustLines()
    if &lines == 48
      set lines+=1
    endif
  endfunction

  function! s:set_font()
    redir => randr_output
      silent !xrandr
    redir END
    let screen_res = matchstr(randr_output, 'current \zs\d\{3,4} x \d\{3,4}')

    if screen_res == "1280 x 800"
      let size = '10'
    else
      let size = '13'
    end
    let &guifont = "Source Code Pro " . size
  endfunction

  augroup gui_autocmds
    au!

    " Having a problem with gvim not properly setting the lines to
    " occupy the fullscreen. This should fix that problem.
    " autocmd GUIEnter * call s:AdjustLines()

    autocmd BufWritePost .gvimrc,gvimrc source $MYGVIMRC
    autocmd VimEnter * call s:set_font()
  augroup END
endif

noremap <leader>g :tabedit $MYGVIMRC<cr>

call Picker()
autocmd VimEnter * echo 'using colorscheme: '.g:colorscheme_file

command! FontSwap call s:font_swap()
