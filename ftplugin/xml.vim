function! s:clean()
  %substitute/></></g
  normal gg=G
endfunction

command! CleanXML call s:clean()
