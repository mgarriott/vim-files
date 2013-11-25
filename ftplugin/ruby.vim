noremap <buffer> <F5> :!ruby -I~/programming/ruby/lib %<CR>
noremap <buffer> <F6> :!ruby -r debug %<CR>

nnoremap <buffer> K :!ri --no-pager -f bs '' \| more<CR>

augroup pry
  autocmd FileType ruby noremap <buffer> <localleader>p orequire 'pry'; binding.pry<esc>
  autocmd FileType eruby noremap <buffer> <localleader>p o<% require 'pry'; binding.pry %><esc>
augroup END

" Abbreviations

" Automatically add end to a define block
" iabbrev def def method_name<enter>end<up><esc>wve<left>
" iabbrev it it "does something" do<enter>end<up><esc>wvi"<left>
