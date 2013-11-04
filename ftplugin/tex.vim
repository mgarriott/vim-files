set textwidth=78
set spell
set formatoptions+=a

function! ToggleAutoFormat()
  if &fo =~? 'a'
    set formatoptions-=a
  else
    set formatoptions+=a
  endif
endfunction

nnoremap <localleader>f :call ToggleAutoFormat()<enter>
