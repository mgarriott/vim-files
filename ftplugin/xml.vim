function! s:clean()
  %substitute/></>
  normal gg=G
endfunction

command! CleanXML call s:clean()