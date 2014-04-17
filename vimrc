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

" Common word screw-ups
iabbrev destory destroy

let mapleader = " "

let g:seek_enable_jumps = 1
let g:snips_author = 'Matt Garriott'

let g:ctrlp_working_path_mode = 'wr'
let g:ctrlp_root_markers = ['.']
let g:ctrlp_follow_symlinks = 1

let g:instant_markdown_slow = 1

let g:utl_cfg_hdl_scm_http_system = "silent !chromium '%u#%f'"
let g:utl_cfg_hdl_scm_http = g:utl_cfg_hdl_scm_http_system
nnoremap <leader>o :Utl<cr>

set hidden
set splitbelow splitright
set tabstop=2 shiftwidth=2 softtabstop=2 expandtab smarttab autoindent
set ignorecase smartcase
set wildmenu wildmode=list:longest
set number
set shiftround
" Prevent strange escape charaters when entering unicode.
set encoding=utf8
set termencoding=utf-8
set listchars=tab:▸\ ,eol:¬
set textwidth=78
set nojoinspaces

if version >= 703
  set relativenumber
  set cryptmethod=blowfish
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

" CtrlP Dirs
nnoremap <leader>pe :CtrlP /etc<enter>
nnoremap <leader>pv :CtrlP $HOME/.vim<enter>
nnoremap <leader>pd :CtrlP $HOME/.dotfiles<enter>

noremap gs :split<space>
noremap gS :vsplit<space>

cnoremap <c-p> <up>
cnoremap <c-n> <down>
cnoremap <c-g> <c-c>

nnoremap <leader>d 0D
nnoremap <localleader>f :call ToggleAutoFormat()<CR>

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

" Write a file as root in a non-root vim session
noremap <leader>wr :write !sudo tee % > /dev/null<CR>

" Read in all of the git commits made today.
noremap <leader>tc :read !git log --branches --pretty=format:"\%s" --since yesterday<cr>

noremap <leader>v :tabedit $MYVIMRC<cr>
noremap <leader>ctw :%substitute/\s\+$//<cr>:write<cr>

nnoremap <leader>p :execute "edit " . GetFTPluginFile()<cr>
nnoremap <leader>P :execute "source " . GetFTPluginFile()<cr>

silent! call pathogen#infect()

if !has("gui_running")
  colorscheme lucius
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
function! TimeEdit()
  0put +
  %s/\n/, /g
  s/[, ]\+$//
  yank +
endfunction

function! QuickfixFilenames()
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

function! ToggleAutoFormat()
  if &fo =~? 'a'
    set formatoptions-=a
  else
    set formatoptions+=a
  endif
endfunction

function! TabEditSnippetFile()
  let snip_file = $HOME . '/.vim/snippets/' . &ft . '.snippets'
  silent execute 'tabedit ' . snip_file
endfunction

function! s:remove(file)
  expand(a:file)
  if filewritable(a:file)
    if delete(a:file) == 0 " Successfully deleted
      execute "bdelete " .  bufnr(src)

      echom "Successfully removed " . a:file
    else
      echoe "Failed to delete file!"
    endif
  else
    echoe "File is not writeable or does not exist. No action taken."
  endif
endfunction

function! s:move(...)
  if a:0 == 1
    " If only one argument is provided we will assume that the provided
    " argument is the destination, and that the source is the current file
    let src = expand('%')
    let dest = expand(a:1)
  elseif a:0 == 2
    " If two arguments are provided, the first argument is the source and
    " the second argument is the destination
    let src = expand(a:1)
    let dest = expand(a:2)
  else
    " If fewer than 1 argument or more than two arguments are provided:
    " exit with an error
    echoe "This function requires either one or two arguments"
    return
  endif

  if isdirectory(dest)
    " If the destination is a directory move the src into that directory
    " keeping the same basename
    let new_file = dest."/".fnamemodify(src, ':t')
    let new_file = substitute(new_file, '/\+', '/', 'g')
  elseif filewritable(dest)
    " If the destination is a file that exists throw an error
    echoe "Move failed. File at destination exists!"
  elseif filewritable(src)
    let new_file = dest
  else
    echoe "Move failed. Source file doesn't exist!"
  endif

  if fnamemodify(src, ':p') != fnamemodify(new_file, ':p')
    let success = rename(src, new_file)

    if success == 0
      let buf_num = bufnr(src)
      execute "edit " . new_file
      execute "bdelete " . buf_num

      echom "Successfully renamed " . src . " to " . new_file
    else
      echoe "Move failed!"
    endif
  else
    echom "Source and destination are the same. No action."
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

function! GetFTPluginFile()
  return $HOME . "/.vim/ftplugin/" . &filetype . ".vim"
endfunction

" Commands
command! -nargs=1 -complete=file Rm call s:remove(<f-args>)
command! -nargs=+ -complete=file Mv call s:move(<f-args>)
command! -nargs=0 -bang BufClear call s:bufClear("<bang>")
command! -nargs=0 Snip call TabEditSnippetFile()
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()

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
