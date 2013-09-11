" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=200 " keep 200 lines of command line history
set ruler       " show the cursor position all the time
set showcmd     " display incomplete commands
set incsearch   " do incremental searching

let mapleader = " "

set hidden
set splitbelow splitright
set tabstop=2 shiftwidth=2 softtabstop=2 expandtab smarttab autoindent
set ignorecase smartcase
set wildmenu wildmode=list:longest
set commentstring=\ #\ %s
set number
set shiftround
" Prevent strange escape charaters when entering unicode.
set encoding=utf8
set listchars=tab:▸\ ,eol:¬
set relativenumber
set cryptmethod=blowfish
set textwidth=78

" Causes error in gvim
if !has("gui_running")
  set termencoding=latin1
endif

" Make :tabn and :tabp easier
nnoremap H :tabprev<enter>
nnoremap L :tabnext<enter>
nnoremap gt :echoe 'Save time! Use L!'<enter>
nnoremap gT :echoe 'Save time! Use H!'<enter>

nnoremap <leader>tf :tabfind<space>
nnoremap <leader>f :find<space>
nnoremap <leader>s :split<space>
nnoremap <leader>te :tabedit<space>

noremap gs :split<space>
noremap gS :vsplit<space>

cnoremap <c-p> <up>
cnoremap <c-n> <down>
cnoremap <c-g> <c-c>

nnoremap <leader>d 0D

" Simplify switching windows
nnoremap <C-h> <C-w><C-h>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-l> <C-w><C-l>

" Simplify moving windows
nnoremap <C-H> <C-w><C-H>
nnoremap <C-K> <C-w><C-K>
nnoremap <C-J> <C-w><C-J>
nnoremap <C-L> <C-w><C-L>

" Swap Jump to Mark keys
noremap ' `
noremap ` '

" Quick commands for opening a file in the current files directory
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" Write a file as root in a non-root vim session
noremap <leader>wr :write !sudo tee % > /dev/null<CR>

" Read in all of the git commits made today.
noremap <leader>tc :read !git log --branches --pretty=format:"\%s" --since yesterday<cr>

noremap <leader>v :tabedit $MYVIMRC<cr>
noremap <leader>ctw :%substitute/\s\+$//<cr>:write<cr>

silent! call pathogen#infect()

if !has("gui_running")
  colorscheme jellybeans
endif

" Don't use Ex mode, use Q for formatting
noremap Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

if exists(":Tabularize")
  nmap <leader>t= :Tabularize /=<CR>
  vmap <leader>t= :Tabularize /=<CR>
  nmap <leader>t: :Tabularize /:\zs<CR>
  vmap <leader>t: :Tabularize /:\zs<CR>
endif

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Custom functions
function! s:move(src, dest)
  let src = expand(a:src)
  let dest = expand(a:dest)

  if filewritable(dest)
    echoe "Move failed. File at destination exists!"
  elseif filewritable(src)

    echom src . " " . dest

    if rename(src, dest) == 0
      echom "Successfully renamed"

      let buf_num = bufnr(src)
      execute "edit " . dest
      execute "bdelete " . buf_num
    else
      echoe "Move failed!"
    endif

  else
    echoe "Move failed. Source file doesn't exist!"
  endif

endfunction

function! s:bufClear(bang)

  redir => bufs
    silent ls
  redir END

  let buf_list = split(bufs, "\n")
  let to_delete = []
  for my_buf in buf_list
    if my_buf =~? "^\\s*\\d\\+\\s*h"
      call add(to_delete, split(my_buf)[0])
    endif
  endfor

  execute "bdelete" . a:bang . " " . join(to_delete)
endfunction

" Commands
command! -nargs=+ -complete=file Mv call s:move(<f-args>)
command! -nargs=0 -bang BufClear call s:bufClear("<bang>")

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Highlight EOL whitespace, http://vim.wikia.com/wiki/Highlight_unwanted_spaces
  highlight ExtraWhitespace ctermbg=darkred guibg=#382424
  augroup my_autocmds
    au!
    autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
    autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
    " the above flashes annoyingly while typing, be calmer in insert mode
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/

    autocmd BufWritePost .vimrc,vimrc source $MYVIMRC
  augroup END

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on
  filetype plugin on
  runtime macros/matchit.vim

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
    au!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

  augroup END

  " Automatically delete fugitive buffers when they are hidden
  autocmd BufReadPost fugitive://* set bufhidden=delete
else

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif
