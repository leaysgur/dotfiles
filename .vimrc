"==============================================================================
" .vimrc
"
" require Vim v8 for dein.
"==============================================================================


"==============================================================================
" Set up
"==============================================================================
if &compatible
  set nocompatible
endif

"==============================================================================
" dein
"==============================================================================
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')
  call dein#add('~/.cache/dein')

  " Devtool
  call dein#add('ajh17/VimCompletesMe')
  call dein#add('neoclide/coc.nvim', { 'merged': 0 })
  call dein#add('codechips/coc-svelte')

  " Editor
  call dein#add('itchyny/lightline.vim')
  call dein#add('nathanaelkane/vim-indent-guides')
  call dein#add('Townk/vim-autoclose')
  call dein#add('tyru/caw.vim')
  call dein#add('vim-scripts/surround.vim')
  call dein#add('vim-scripts/matchit.zip')
  call dein#add('haya14busa/is.vim')
  call dein#add('mattn/emmet-vim')

  " Syntax
  call dein#add('othree/html5.vim')
  call dein#add('hail2u/vim-css3-syntax')
  call dein#add('pangloss/vim-javascript')
  call dein#add('cakebaker/scss-syntax.vim')
  call dein#add('chemzqm/vim-jsx-improve')
  call dein#add('elzr/vim-json')
  call dein#add('myhere/vim-nodejs-complete')
  call dein#add('leafgarland/typescript-vim')
  call dein#add('evanleck/vim-svelte')
  call dein#add('rust-lang/rust.vim')

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

let g:dein#install_github_api_token = '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'

"==============================================================================
" Base
"==============================================================================
colorscheme default
filetype plugin indent on
syntax enable

" 行数表示を有効にする
set number
" 折り返す
set wrap

" 括弧入力で対応する括弧を一瞬強調
set showmatch

" 不可視文字の表示
set list
set listchars=tab:>-,trail:-,nbsp:%,extends:>,precedes:<

" BSでindent, 改行, 挿入開始前の文字を削除
set backspace=indent,eol,start

" インデント類の設定
set cindent

" Tabまわり
set smarttab
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

" ノーマルモードでEnterキーで改行挿入
noremap <CR> o<ESC>

" シンタックスのエイリアス
autocmd BufNewFile,BufReadPost *.jsx set filetype=javascript
autocmd BufNewFile,BufReadPost *.tsx set filetype=typescript
autocmd BufNewFile,BufReadPost *.ejs set filetype=html
autocmd BufNewFile,BufReadPost *.md set filetype=markdown


"==============================================================================
" Search
"==============================================================================
" 検索文字列を色づけ
set hlsearch
" 大文字小文字を判別しない
set ignorecase
" でも大文字小文字が混ざって入力されたら区別する
set smartcase
" インクリメンタルサーチ
set incsearch


"==============================================================================
" Lang
"==============================================================================
set ambiwidth=double


"==============================================================================
" Completion
"==============================================================================
" FilePathの補完時の起点となるパスを、pwdではなく開いたファイルにする
set autochdir

" 補完ポップアップの配色
hi Pmenu    ctermfg=white    ctermbg=darkblue
hi PmenuSel ctermfg=darkblue ctermbg=white


"==============================================================================
" emmet
"==============================================================================
let g:user_emmet_leader_key = '<C-e>'
let g:user_emmet_settings = {
\  'indentation' : '  ',
\}


"==============================================================================
" vim-indent-guides
"==============================================================================
" インデントガイドを有効に
let g:indent_guides_enable_on_vim_startup = 1
" ガイドの幅
let g:indent_guides_guide_size = 1
" 1インデント目からガイドする
let g:indent_guides_start_level = 2
" 自動カラーを無効にして手動で設定する
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd  ctermbg=lightblue
hi IndentGuidesEven ctermbg=darkgray


"==============================================================================
" lightline
"==============================================================================
" ステータスラインを常に表示
set laststatus=2
let g:lightline = {
\ 'colorscheme': 'wombat',
\  'component': {
\    'readonly': '%{&readonly ? "[RO]" : ""}',
\  },
\  'active': {
\    'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'modified' ] ],
\    'right': [ [ 'lineinfo' ], [ 'fileencoding', 'filetype' ] ]
\  },
\  'subseparator': { 'left': ' ', 'right': '/' }
\}


"==============================================================================
" tyru/caw
" ==============================================================================
nmap <C-_><C-_> <Plug>(caw:hatpos:toggle)
vmap <C-_><C-_> <Plug>(caw:hatpos:toggle)


"==============================================================================
" Misc
"==============================================================================
" .swp/~ は、邪魔にならない場所に
set directory=/tmp
set backupdir=/tmp

" インデント後も続けてビジュアルモード
:vnoremap < <gv
:vnoremap > >gv

" vimrcもlocalで欲しい
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif
