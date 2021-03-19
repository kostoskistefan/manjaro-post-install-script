call plug#begin()
    Plug 'matze/vim-move'                                   " Move whole lines with Alt key                 
    Plug 'sainnhe/sonokai'                                  " Neovim theme                           
    Plug 'neoclide/coc.nvim'                                " Autocompletion Plugin
    Plug 'preservim/nerdtree'                               " Show file tree on the left
    Plug 'alvan/vim-closetag'                               " Automatically close html tags
    Plug 'frazrepo/vim-rainbow'                             " Rainbow color brackets
    Plug 'jiangmiao/auto-pairs'                             " Automatically create brackets, quote pairs
    Plug 'sheerun/vim-polyglot'                             " Syntax highlighting for many languages
    Plug 'itchyny/lightline.vim'                            " Bottom status line theming
    Plug 'voldikss/vim-floaterm'                            " Open floating terminal with F12
    Plug 'junegunn/fzf.vim'                                 " Fuzzy Finder
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }     " Fuzzy Finder addition                                  
call plug#end()

" Rainbow brackets
let g:rainbow_active = 1

" Fuzzy Finder
nmap <silent> <C-e> :FZF<CR>

" Coc Configuration
source $HOME/.config/nvim/coc.vim

" Floating Terminal Configuration
source $HOME/.config/nvim/float.vim

" Neovim Configuration
source $HOME/.config/nvim/neovim.vim

" NERDTree Configuration
source $HOME/.config/nvim/nerdtree.vim
