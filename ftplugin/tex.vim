set textwidth=78
set spell
set formatoptions+=a

nnoremap <localleader>f :call ToggleAutoFormat()<enter>

augroup matts_tex
  autocmd!
  " Automatically convert tex files to PDF on write
  autocmd BufWritePost *.tex :silent !texi2pdf -s %
augroup END
