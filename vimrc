" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=200		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

"Matt's additions
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

" Causes error in gvim
if !has("gui_running")
  set termencoding=latin1
endif

if has("ruby")
  " Find the current date and and write it after the cursor.
  function! WriteDate()
    ruby require 'date'
    ruby VIM::command('let date = "' + Date.today.to_s + '"')
    let temp = @d
    let @d = date
    normal "dp
    let @d = temp
  endfunction
  command! WriteDate call WriteDate()
endif

noremap  :echo "Nope!"<CR>
inoremap  Nope!
cnoremap Tab tab
noremap gs :split<space>
noremap gS :vsplit<space>

cnoremap <c-p> <up>
cnoremap <c-n> <down>

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

" Highlight EOL whitespace, http://vim.wikia.com/wiki/Highlight_unwanted_spaces
highlight ExtraWhitespace ctermbg=darkred guibg=#382424
augroup my_autocmds
  au!
  autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
  autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
  " the above flashes annoyingly while typing, be calmer in insert mode
  autocmd InsertLeave * match ExtraWhitespace /\s\+$/
  autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/

  autocmd BufWritePost .vimrc source $MYVIMRC
augroup END

call pathogen#infect()

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
noremap Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

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

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on
  filetype plugin on

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

else

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif
