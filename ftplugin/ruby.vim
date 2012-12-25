noremap <buffer> <F5> :!ruby -I~/programming/ruby/lib %<CR>
noremap <buffer> <F6> :!ruby -r debug %<CR>

augroup pry
  autocmd FileType ruby noremap <buffer> <localleader>p orequire 'pry'; binding.pry<esc>
  autocmd FileType eruby noremap <buffer> <localleader>p o<% require 'pry'; binding.pry %><esc>
augroup END
