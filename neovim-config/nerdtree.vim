" NERDTree Configuration

" Hide brackets around folders
" Has to be on top for the bellow commands to word
" if exists('g:loaded_webdevicons')
"     call webdevicons#refresh()
" endif
" autocmd VimEnter * source /home/scyllius/.config/nvim/init.vim

" Switch to main window after opening NERDTree
" autocmd VimEnter * NERDTree | wincmd p

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
            \ quit | endif

" Enable Mouse support
let g:NERDTreeMouseMode=3

" Hide Cursor line
let NERDTreeHighlightCursorline=0

" Toggle NERDTree
nmap <C-n> :NERDTreeToggle<CR>

let g:NERDTreeMinimalUI = 1
