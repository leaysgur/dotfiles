"==============================================================================
" .vimrc
"==============================================================================
" Requirement:
"   using NeoBundle for all plug-in installation.
"   using Solarized color scheme.


"==============================================================================
" NeoBundle settings.
"==============================================================================
set nocompatible " Be iMproved

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Let NeoBundle manage NeoBundle
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

" Recommended to install
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows': 'echo "Sorry, cannot update vimproc binary file in Windows."',
      \     'cygwin':  'make -f make_cygwin.mak',
      \     'mac':     'make -f make_mac.mak',
      \     'unix':    'make -f make_unix.mak',
      \    },
      \ }
" My Bundles.
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'taichouchou2/html5.vim'
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'cakebaker/scss-syntax.vim'
NeoBundle 'jelera/vim-javascript-syntax'
NeoBundle 'elzr/vim-json'
NeoBundle 'myhere/vim-nodejs-complete'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'Townk/vim-autoclose'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'surround.vim'
NeoBundle 'vim-scripts/matchit.zip'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'editorconfig/editorconfig-vim'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'mxw/vim-jsx'

call neobundle#end()

" Installation check.
NeoBundleCheck
filetype plugin indent on


"==============================================================================
" Zen-coding settings.
"==============================================================================
" NeocomplcacheでZen-codingの補完を有効に
let g:use_emmet_complete_tag = 1
let g:user_emmet_leader_key='<C-e>'
let g:user_emmet_settings = {
\  'lang' : 'ja',
\  'indentation' : '  ',
\  'html': {
\    'filters': 'html, fc'
\  },
\  'hbs' : {
\    'extends' : 'html',
\    'filters' : 'html, fc',
\  },
\  'ejs' : {
\    'extends' : 'html',
\    'filters' : 'html, fc',
\  },
\  'css': {
\    'filters': 'html, fc'
\  },
\  'scss' : {
\    'extends' : 'css',
\    'filters' : 'html, fc',
\  }
\}


"==============================================================================
" Syntastic settings.
"==============================================================================
let g:syntastic_mode_map = {
\  "mode": "passive",
\  "active_filetypes": ["javascript"],
\  "passive_filetypes": ["html"],
\}

" ESlint試すのでしばし
let g:syntastic_javascript_checkers = ['eslint', 'flow']
let g:syntastic_javascript_eslint_exec = 'eslint_d'
" let g:syntastic_javascript_checkers = ['jshint']
" .eslintrcの場所を動的にさかのぼってみつける
function s:find_eslintrc(dir)
    let l:found = globpath(a:dir, '.eslintrc')
    if filereadable(l:found)
        return l:found
    endif

    let l:parent = fnamemodify(a:dir, ':h')
    if l:parent != a:dir
        return s:find_eslintrc(l:parent)
    endif

    return "~/.eslintrc"
endfunction

function UpdateEslintConf()
    let l:dir = expand('%:p:h')
    let l:eslintrc = s:find_eslintrc(l:dir)
    let g:syntastic_javascript_eslint_args = '--config ' . l:eslintrc
endfunction

au BufEnter * call UpdateEslintConf()


"==============================================================================
" Neocomplcache/Neosnippet settings.
"==============================================================================
" 補完ウィンドウの設定
set completeopt=menuone
" 起動時に有効化
let g:neocomplcache_enable_at_startup = 1
" 大文字が入力されるまで大文字小文字の区別を無視する
let g:neocomplcache_enable_smart_case = 1
" _(アンダースコア)区切り、キャメルケースの補完を有効化
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_enable_camel_case_completion  =  1
" ポップアップメニューで表示される候補の数
let g:neocomplcache_max_list = 5
" 補完を開始する文字数
let g:neocomplcache_auto_completion_start_length = 2
" シンタックスをキャッシュするときの最小文字長
let g:neocomplcache_min_syntax_length = 2
" ディクショナリ定義
let g:neocomplcache_dictionary_filetype_lists = {
  \ 'default' : '',
\ }
let g:neosnippet#disable_runtime_snippets = {
  \   '_' : 1,
\ }
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
" スニペットを展開する。スニペットが関係しないところでは行末まで削除
imap <expr><C-k> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : "\<C-o>D"
smap <expr><C-k> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : "\<C-o>D"
" 前回行われた補完をキャンセルします
inoremap <expr><C-g> neocomplcache#undo_completion()
" 補完候補のなかから、共通する部分を補完します
inoremap <expr><C-l> neocomplcache#complete_common_string()
" 改行で補完ウィンドウを閉じる
inoremap <expr><CR> pumvisible() ? neocomplcache#close_popup() : "\<CR>"
" <C-h>や<BS>を押したときに確実にポップアップを削除
inoremap <expr><C-h> neocomplcache#smart_close_popup().”\<C-h>”
" 現在選択している候補を確定
inoremap <expr><C-y> neocomplcache#close_popup()
" 現在選択している候補をキャンセルし、ポップアップを閉じ
inoremap <expr><C-e> neocomplcache#cancel_popup()
"tabで補完候補の選択を行う
inoremap <expr><TAB>   pumvisible() ? "\<Down>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<Up>"   : "\<S-TAB>"
" ポップアップメニューの配色
highlight Pmenu     ctermbg=8
highlight PmenuSel  ctermbg=1
highlight PmenuSbar ctermbg=0
" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)"
  \: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)"
  \: "\<TAB>"
" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif


"==============================================================================
" Vimfiler settings.
"==============================================================================
let g:vimfiler_as_default_explorer = 1
" エンターキーでファイルを開く
let g:vimfiler_execute_file_list = {}
let g:vimfiler_execute_file_list['_'] = 'vim'
" ファイルの書き込み、削除とか可能に
let g:vimfiler_safe_mode_by_default = 0
set modifiable
set write


"==============================================================================
" Unite settings.
"==============================================================================
" 入力モードで開始しない
let g:unite_enable_start_insert=0
" 最近使ったファイルの一覧
noremap <C-U><C-R> :Unite -vertical file_mru<CR>
" ファイルとバッファ
noremap <C-U><C-U> :Unite -vertical buffer file_mru<CR>
" Outline
noremap <C-U><C-O> :Unite -no-quit -vertical -winwidth=40 outline<CR>


"==============================================================================
" 見た目関係
"==============================================================================
" いちおう、Syntaxを有効にしてから
syntax on
" カラースキームを使用
colorscheme solarized
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1

" ステータスラインとかに色つかないときのおまじない
if !has('gui_running')
  set t_Co=256
endif

" ejsファイルをhtmlと同じシンタックスに
autocmd BufNewFile,BufReadPost *.ejs set filetype=html
" mdファイルをmarkdownシンタックスに
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
" json5ファイルをjsシンタックスに
autocmd BufNewFile,BufReadPost *.json5 set filetype=javascript

" ルーラを表示
set ruler
" 括弧入力で対応する括弧を一瞬強調
set showmatch

" インデントガイドを有効に
let g:indent_guides_enable_on_vim_startup = 1
" ガイドの幅
let g:indent_guides_guide_size = 1
" 1インデント目からガイドする
let g:indent_guides_start_level = 2
" 自動カラーを無効にして手動で設定する
let g:indent_guides_auto_colors = 0
" 奇数インデントのガイドカラー
hi IndentGuidesOdd  ctermbg=cyan
" 偶数インデントのガイドカラー
hi IndentGuidesEven ctermbg=yellow


"==============================================================================
" ステータスライン関係
"==============================================================================
" ステータスラインを常に表示
set laststatus=2
" Vim-lightline
let g:lightline = {
\  'colorscheme': 'solarized',
\  'component': {
\    'readonly': '%{&readonly?"ReadOnly |":"Editable |"}',
\  },
\  'active': {
\    'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'modified' ] ]
\  },
\  'subseparator': { 'left': ' ', 'right': '/' }
\}

"==============================================================================
" 検索関係
"==============================================================================
" 検索文字列を色づけ
set hlsearch
" 大文字小文字を判別しない
set ignorecase
" でも大文字小文字が混ざって入力されたら区別する
set smartcase
" インクリメンタルサーチ
set incsearch
" Esc *2 でハイライト解除
nmap <ESC><ESC> :nohlsearch<CR><ESC>


"==============================================================================
" 文字コード関係
"==============================================================================
" vim 内部の文字コード（ブランクバッファの文字コードに影響）
set enc=utf-8
" デフォルトのファイル文字コード
set fenc=utf-8
" 対応する文字コード
set fencs=utf-8,iso-2022-jp,euc-jp,cp932
set langmenu=ja_JP.utf-8


"==============================================================================
" デフォルトエンコーディング
"   □とか○の文字があってもカーソル位置がずれないようにする
"   文字コードの自動判別機能は下に記述
"==============================================================================
set termencoding=utf-8
set fileformats=unix,dos,mac
if exists('&ambiwidth')
  set ambiwidth=double
endif


"==============================================================================
" その他の設定
"==============================================================================
" .swp/~ は、邪魔にならない場所に
set directory=/tmp
set backupdir=/tmp

" 行数表示を有効にする
set number
" 折り返す
set wrap
" BSでindent, 改行, 挿入開始前の文字を削除
set backspace=indent,eol,start
" インデント類の設定
set cindent
" 行頭でTabを有効に
set smarttab
" ソフトタブ
set expandtab
" いかなるときも4つ
set tabstop=2
set softtabstop=2
set shiftwidth=2
" インデント後も続けてビジュアルモード
:vnoremap < <gv
:vnoremap > >gv
" 不可視文字の表示
set list
set listchars=tab:>-,trail:-,nbsp:%,extends:>,precedes:<
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
" ノーマルモードでEnterキーで改行挿入
noremap <CR> o<ESC>
" vimrcもlocalで欲しい
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif
