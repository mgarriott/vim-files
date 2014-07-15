function! s:set_filetype(type)
  execute 'set filetype=' . a:type
endfunction

augroup filetypes
  au!

  " Ruby
  au BufRead,BufNewFile *.thor        call s:set_filetype('ruby')
  au BufRead,BufNewFile Guardfile     call s:set_filetype('ruby')
augroup END
