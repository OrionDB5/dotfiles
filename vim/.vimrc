call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdcommenter'
Plug 'arcticicestudio/nord-vim'
Plug 'chriskempson/base16-vim'

call plug#end()

filetype plugin on

set number
syntax on
syntax enable

colorscheme base16-default-dark
set background=dark

"set clipboard+=unnamed
set clipboard=unnamedplus
set hlsearch

noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p

