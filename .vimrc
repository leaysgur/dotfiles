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
" Fuzzy finder
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mattn/ctrlp-matchfuzzy'
" Emmet
Plug 'mattn/emmet-vim'
" LSP support
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'rhysd/vim-healthcheck'
" Auto-complete
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
" Syntax highlights not supported by LSP
Plug 'maxmellon/vim-jsx-pretty'
Plug 'leafOfTree/vim-svelte-plugin'
Plug 'wuelnerdotexe/vim-astro'

call plug#end()


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
vmap <C-_> <Plug>(caw:hatpos:toggle)

" For emmet-vim
let g:user_emmet_leader_key = '<C-e>'

" For ctrlp.vim
let g:ctrlp_match_func = {'match': 'ctrlp_matchfuzzy#matcher'}
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|node_modules\|log\|tmp$',
  \ 'file': '\.so$\|\.dat$|\.DS_Store$'
  \ }

" For vim-lsp
let g:lsp_use_native_client = 1
let g:lsp_document_code_action_signs_enabled = 0
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_diagnostics_highlights_enabled = 0
let g:lsp_inlay_hints_enabled = 1
let g:lsp_semantic_enabled = 1
nmap gs :sp<CR>:LspDefinition<CR>
nmap gv :vsp<CR>:LspDefinition<CR>
nmap <buffer> gr <Plug>(lsp-references)
nmap <Space> <Plug>(lsp-hover)
nmap <C-f> <Plug>(lsp-document-format)

" For asynccomplete.vim
set shortmess+=c
inoremap <expr> <Tab> pumvisible() ? '<C-n>' : '<Tab>'
inoremap <expr> <S-Tab> pumvisible() ? '<C-p>' : '<S-Tab>'
inoremap <expr> <CR> pumvisible() ? asyncomplete#close_popup() : '<CR>'

" For lightline
let g:lightline = { 'colorscheme': 'rosepine' }
