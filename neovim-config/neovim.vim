" Neovim Config
syntax on
set number
set mouse=a
set undofile
set tabstop=4
set expandtab
set noshowmode
set pyxversion=3
set shiftwidth=4
set termguicolors
set encoding=UTF-8
colorscheme sonokai
set clipboard=unnamedplus
filetype plugin indent on
set undodir=~/.vim/undodir
set omnifunc=syntaxcomplete#Complete
let g:lightline = {'colorscheme': 'wombat'}

" Create alias for W and Q to write and exit from vim
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev WQ wq
cnoreabbrev Wq wq
