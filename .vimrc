"==============================================================================
" .vimrc
"
" require Vim v8 for dein and ale.
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
  call dein#add('w0rp/ale')

  " Editor
  call dein#add('itchyny/lightline.vim')
  call dein#add('nathanaelkane/vim-indent-guides')
  call dein#add('tomtom/tcomment_vim')
  call dein#add('Townk/vim-autoclose')
  call dein#add('vim-scripts/surround.vim')
  call dein#add('vim-scripts/matchit.zip')
  call dein#add('haya14busa/is.vim')
  call dein#add('mattn/emmet-vim')
  call dein#add('editorconfig/editorconfig-vim')

  " Syntax
  call dein#add('othree/html5.vim')
  call dein#add('hail2u/vim-css3-syntax')
  call dein#add('cakebaker/scss-syntax.vim')
  call dein#add('chemzqm/vim-jsx-improve')
  call dein#add('elzr/vim-json')
  call dein#add('myhere/vim-nodejs-complete')
  call dein#add('posva/vim-vue')
  call dein#add('leafgarland/typescript-vim')
  call dein#add('elixir-editors/vim-elixir')
  call dein#add('styled-components/vim-styled-components')

  call dein#end()
  call dein#save_state()
endif


"==============================================================================
" Base
"==============================================================================
filetype plugin indent on

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


"==============================================================================
" Theme, Syntax
"==============================================================================
syntax enable

" シンタックスのエイリアス
autocmd BufNewFile,BufReadPost *.ejs set filetype=html
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufReadPost *.pcss set filetype=scss


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
" vim 内部の文字コード（ブランクバッファの文字コードに影響）
set enc=utf-8
" デフォルトのファイル文字コード
set fenc=utf-8
" 対応する文字コード
set fencs=utf-8,iso-2022-jp,euc-jp,cp932
set langmenu=ja_JP.utf-8
set termencoding=utf-8
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif


"==============================================================================
" Completion
"==============================================================================
set omnifunc=syntaxcomplete#Complete

" オムニ補完をTabで使う
function InsertTabWrapper()
  if pumvisible()
    return "\<Down>"
  endif

  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k\|<\|/'
    return "\<TAB>"
  elseif exists('&omnifunc') && &omnifunc == ''
    return "\<C-n>"
  else
    return "\<C-x>\<C-o>"
  endif
endfunction

inoremap <TAB> <C-r>=InsertTabWrapper()<CR>
" いきなり<S-TAB>することはないし、候補選択時のためだけにマッピングしておく
inoremap <expr><S-TAB> pumvisible() ? "\<Up>" : "\<S-TAB>"

" 補完ポップアップの配色
hi Pmenu    ctermfg=white    ctermbg=darkblue
hi PmenuSel ctermfg=darkblue ctermbg=white


"==============================================================================
" emmet
"==============================================================================
let g:user_emmet_leader_key = '<C-e>'
let g:user_emmet_settings = {
\  'variables': { 'lang' : 'ja' },
\  'indentation' : '  ',
\}


"==============================================================================
" ale
"==============================================================================
let g:ale_linters = {
\   'html': [],
\   'javascript': ['eslint'],
\   'typescript': ['tslint', 'tsserver', 'typecheck'],
\   'elixir': ['credo'],
\   'rust': ['cargo', 'rls'],
\}
let g:ale_fixers = {
\   'javascript': ['eslint'],
\   'typescript': ['tslint'],
\   'rust': ['rustfmt'],
\}
let g:ale_lint_delay = 1000
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1
let g:ale_rust_rls_toolchain = 'stable'
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_typescript_prettier_use_local_config = 1


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
" Misc
"==============================================================================
" .swp/~ は、邪魔にならない場所に
set directory=/tmp
set backupdir=/tmp

" インデント後も続けてビジュアルモード
:vnoremap < <gv
:vnoremap > >gv

" 勝手にコメントアウトされるのを防ぐ
autocmd FileType * setlocal formatoptions-=ro

" 保存時に行末の空白を除去する
function! s:remove_dust()
  let cursor = getpos(".")
  %s/\s\+$//ge
  call setpos(".", cursor)
  unlet cursor
endfunction
autocmd BufWritePre * call <SID>remove_dust()

" Escキーを早く
set timeout timeoutlen=200 ttimeoutlen=75

" vimrcもlocalで欲しい
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif
