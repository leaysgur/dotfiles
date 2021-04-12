" ================================================================
" Plugin settings
" ================================================================
" Install vim-plug if not installed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" Indent auto detect
Plug 'tpope/vim-sleuth'
" Toggle comment
Plug 'tyru/caw.vim'
" Emmet
Plug 'mattn/emmet-vim'

" Completion, LSP support, etc...
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Syntax highlights not default supported by coc
Plug 'maxmellon/vim-jsx-pretty'
Plug 'leafOfTree/vim-svelte-plugin'

" Color scheme
Plug 'cocopon/iceberg.vim'
" Rich status line
Plug 'itchyny/lightline.vim'
" Show indent guides
Plug 'nathanaelkane/vim-indent-guides'
call plug#end()

" After installing coc.nvim, run
" :CocInstall coc-json coc-html coc-css coc-eslint coc-tsserver coc-svelte


" ================================================================
" Editor settings
" ================================================================
" BS(or DEL) key can remove
set backspace=indent,eol,start

" Make ESC key quick
set ttimeout ttimeoutlen=0

" Keep visual mode in indenting
vnoremap < <gv
vnoremap > >gv

" Keep .swp far away
set backupdir=/tmp
" Disable .un~
set noundofile

" ================================================================
" View settings
" ================================================================
set background=dark
colorscheme iceberg

" Show line number
set number
" Show invisible characters
set list listchars=tab:»-,trail:-

" Show status bar
set laststatus=2 noshowmode

" Highlight
highlight Pmenu ctermfg=white ctermbg=black
highlight PmenuSel ctermfg=black ctermbg=white


" ================================================================
" Search settings
" ================================================================
set hlsearch smartcase incsearch ignorecase
" Clear search highlight
nnoremap <CR> :noh<CR><CR>


" ================================================================
" Plugin specific settings
" ================================================================
" For vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
let g:indent_guides_auto_colors = 0
highlight IndentGuidesOdd  ctermbg=darkgray
highlight IndentGuidesEven ctermbg=gray

" For lightline
let g:lightline = {
  \ 'colorscheme': 'iceberg',
  \ }

" For caw.vim
nmap <C-_><C-_> <Plug>(caw:hatpos:toggle)
vmap <C-_><C-_> <Plug>(caw:hatpos:toggle)

" For emmet-vim
let g:user_emmet_leader_key = '<C-e>'

" For coc.nvim
set encoding=utf-8
set hidden
set nobackup
set nowritebackup
set updatetime=300
set shortmess+=c
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
highlight CocErrorSign ctermfg=darkred
highlight CocWarningSign ctermfg=darkyellow
highlight CocHintSign ctermfg=darkgreen
highlight CocInfoSign ctermfg=darkgray

" For vim-svelte-plugin
let g:vim_svelte_plugin_use_typescript = 1
let g:vim_svelte_plugin_use_sass = 1
