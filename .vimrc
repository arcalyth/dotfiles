
" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set modeline
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set number		" show line numbers
set showcmd		" display incomplete commands

set textwidth=80

set tabstop=8
set shiftwidth=4
set softtabstop=4
set autoindent		" always set autoindenting on

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" syntax highlighting
syntax on
set background=dark
let g:solarized_termcolors=16
let g:solarized_termtrans=1
colorscheme solarized

" Enable file type detection.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" make
set errorformat="%f:%l:\%m"

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif
