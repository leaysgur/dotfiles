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

" Color scheme
Plug 'cocopon/iceberg.vim'
" Rich status line
Plug 'itchyny/lightline.vim'
" Show indent guides
Plug 'nathanaelkane/vim-indent-guides'
" Indent auto detect
Plug 'tpope/vim-sleuth'
" Toggle comment
Plug 'tyru/caw.vim'
" Better matchit
Plug 'andymass/vim-matchup'
" Completion, LSP support, etc...
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
" Fuzzy finder
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mattn/ctrlp-matchfuzzy'
" Emmet
Plug 'mattn/emmet-vim'
" Syntax highlights not default supported by coc
Plug 'maxmellon/vim-jsx-pretty'
Plug 'leafOfTree/vim-svelte-plugin'
Plug 'cespare/vim-toml'
Plug 'lepture/vim-jinja'
Plug 'mustache/vim-mustache-handlebars'
Plug 'wuelnerdotexe/vim-astro'

call plug#end()

" After installing coc.nvim, run
" :CocInstall coc-json coc-toml coc-html coc-css coc-eslint coc-tsserver coc-svelte coc-rls, etc...


" ================================================================
" Editor settings
" ================================================================
" Use utf-8
set encoding=utf-8

" BS(or DEL) key can remove
set backspace=indent,eol,start

" Make ESC key quick
set ttimeout ttimeoutlen=0

" Keep visual mode in indenting
vnoremap < <gv
vnoremap > >gv

" Enable .swp but put it far away
set directory=/tmp
set updatetime=300
" Disable backup
set nobackup nowritebackup
" Disable .un~
set noundofile


" ================================================================
" View settings
" ================================================================
set background=dark
set termguicolors
colorscheme iceberg

" Show line number
set number
" Show invisible characters
set list listchars=tab:»-,trail:-
set tabstop=2

" Show status bar
set laststatus=2 noshowmode


" ================================================================
" Search settings
" ================================================================
set hlsearch smartcase incsearch ignorecase
" Clear search highlight on Enter
nnoremap <CR> :noh<CR><CR>


" ================================================================
" Netrw settings
" ================================================================
let g:netrw_liststyle = 3
" Update current dir to make netrw open in current dir
set autochdir


" ================================================================
" Plugin specific settings
" ================================================================
" For vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2

" For caw.vim
nmap <C-_> <Plug>(caw:hatpos:toggle)

" For emmet-vim
let g:user_emmet_leader_key = '<C-e>'

" For coc.nvim
set shortmess+=c
inoremap <silent><expr> <CR>
  \ coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <TAB>
  \ coc#pum#visible() ? coc#pum#confirm() :
  \ <SID>check_back_space() ? "\<Tab>" :
  \ coc#refresh()
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
nmap <silent> gs :sp<CR><Plug>(coc-definition)
nmap <silent> gv :vs<CR><Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)

" For ctrlp.vim
let g:ctrlp_match_func = {'match': 'ctrlp_matchfuzzy#matcher'}
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|node_modules\|log\|tmp$',
  \ 'file': '\.so$\|\.dat$|\.DS_Store$'
  \ }

" For lightline
function! CocCurrentFunction()
  return get(b:, 'coc_current_function', '')
endfunction

let g:lightline = {
  \ 'colorscheme': 'iceberg',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ]
  \ },
  \ 'component_function': {
  \   'cocstatus': 'coc#status',
  \   'currentfunction': 'CocCurrentFunction'
  \ },
  \ }

" For vim-svelte-plugin
" let g:vim_svelte_plugin_use_typescript = 1
" let g:vim_svelte_plugin_use_sass = 1
