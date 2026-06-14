syntax enable
filetype plugin indent on

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent smartindent

set lazyredraw
set hidden
set splitbelow
set splitright
set scrolloff=3

set nobackup
set nowritebackup
set noswapfile

set ignorecase smartcase
set nohlsearch
set incsearch

set nonumber
set laststatus=2
set vb t_vb=

" keymaps
let mapleader = ","
inoremap jk <esc>
noremap <space> :
inoremap <C-c> <Esc>
vnoremap // y/<c-r>"<cr>

noremap j gj
noremap k gk

noremap <c-j> <c-w>j
noremap <c-h> <c-w>h
noremap <c-k> <c-w>k
noremap <c-l> <c-w>l

set pastetoggle=<F2>

" autocmds and utilities
autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])

function! RpcXml()
    silent! %s/></>\r</g
    normal gg=Ggg
endfunction

function! CleanSpecalCharsFromLog()
    silent! %s/\%x1b\[\d\d*m//g
    silent! %s/\r//g
endfunction


packadd! editorconfig

" PLUGINS
"
" call plug#begin()
"
" Plug 'tpope/vim-surround'
" Plug 'tpope/vim-commentary'
" Plug 'ctrlpvim/ctrlp.vim'
" Plug 'junegunn/vim-easy-align'
"
" call plug#end()
"
"
" let g:ctrlp_cmd = 'CtrlPMixed'
" let g:go_fmt_command = "goimports"
"
" " vim-easy-align
" xmap ga <Plug>(EasyAlign)
" nmap ga <Plug>(EasyAlign)
