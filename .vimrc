"==============================================================================
" .vimrc
"==============================================================================
" Requirement:
"   using NeoBundle for all plug-in installation.
"   using Solarized color scheme.


"==============================================================================
" NeoBundle settings.
"==============================================================================
set nocompatible               " Be iMproved

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'
" Recommended to install
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'echo "Sorry, cannot update vimproc binary file in Windows."',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
" My Bundles.
NeoBundle 'mattn/zencoding-vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/unite.vim'
NeoBundle "h1mesuke/unite-outline"
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'taichouchou2/html5.vim'
NeoBundle 'taichouchou2/vim-javascript'
NeoBundle 'Townk/vim-autoclose'
NeoBundle 'cakebaker/scss-syntax.vim'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'surround.vim'
NeoBundle 'scrooloose/syntastic'

" Installation check.
NeoBundleCheck
filetype plugin indent on


"==============================================================================
" Zen-coding settings.
"==============================================================================
" NeocomplcacheでZen-codingの補完を有効に
let g:use_zen_complete_tag = 1
let g:user_zen_leader_key = '<C-e>'
let g:user_zen_settings = {
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
\  "mode": "active",
\  "active_filetypes": [],
\  "passive_filetypes": ["html"],
\}
let g:syntastic_javascript_checker = 'jshint'

"==============================================================================
" Neocomplcache settings.
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
" 1つ目の候補を自動選択
let g:neocomplcache_enable_auto_select = 1
" 補完を開始する文字数
let g:neocomplcache_auto_completion_start_length = 2
" シンタックスをキャッシュするときの最小文字長
let g:neocomplcache_min_syntax_length = 2
" ディクショナリ定義
let g:neocomplcache_dictionary_filetype_lists = {
  \ 'default' : '',
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
"tabで補完候補の選択を行う
inoremap <expr><TAB> pumvisible() ? "\<Down>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<Up>" : "\<S-TAB>"
" <C-h>や<BS>を押したときに確実にポップアップを削除します
inoremap <expr><C-h> neocomplcache#smart_close_popup().”\<C-h>”
" 現在選択している候補を確定します
inoremap <expr><C-y> neocomplcache#close_popup()
" 現在選択している候補をキャンセルし、ポップアップを閉じます
inoremap <expr><C-e> neocomplcache#cancel_popup()
" ポップアップメニューの配色
highlight Pmenu ctermbg=8
highlight PmenuSel ctermbg=1
highlight PmenuSbar ctermbg=0


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
" txファイルをhtmlと同じシンタックスに
autocmd BufNewFile,BufReadPost *.tx set filetype=html
" scssファイルをsassと同じシンタックスに
autocmd BufNewFile,BufReadPost *.scss set filetype=sass

" ルーラを表示
set ruler
" 括弧入力で対応する括弧を一瞬強調
set showmatch


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
" 日本語文字コードの自動判別
"==============================================================================
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif

" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif


"==============================================================================
" その他の設定
"==============================================================================
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
" 拡張子別でタブ設定
autocmd BufNewFile,BufRead *.tx   set tabstop=2 shiftwidth=2   et
autocmd BufNewFile,BufRead *.ejs  set tabstop=2 shiftwidth=2   et
autocmd BufNewFile,BufRead *.html set tabstop=2 shiftwidth=2   et
autocmd BufNewFile,BufRead *.scss set tabstop=2 shiftwidth=2   et
autocmd BufNewFile,BufRead *.css  set tabstop=2 shiftwidth=2   et
autocmd BufNewFile,BufRead *.js   set tabstop=2 shiftwidth=2   et
autocmd BufNewFile,BufRead *.pm   set tabstop=2 shiftwidth=2 noet
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
