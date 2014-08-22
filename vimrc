" Handy vanilla Vim settings
set background=dark
set incsearch
set wildmenu
set wildmode=longest,list
set backspace=indent,eol,start
set laststatus=2
set ruler

" Ironman mode
"map <Left> <Nop>
"map <Right> <Nop>
"map <Up> <Nop>
"map <Down> <Nop>
"imap <Left> <Nop>
"imap <Right> <Nop>
"imap <Up> <Nop>
"imap <Down> <Nop>

" Indenting things
set autoindent
set expandtab
set smarttab
set shiftwidth=2
set tabstop=2
" Special Python indenting
au FileType python setl sw=4

" Line number toggling
function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber
    set number
    highlight LineNr ctermfg=darkgray
  else
    set relativenumber
    highlight LineNr ctermfg=gray
  endif
endfunc
nnoremap <C-n> :call NumberToggle()<CR>
set relativenumber
highlight LineNr ctermfg=gray

" Mail command
command Mail !email.sh 'tal@intranet.datcon.co.uk' %

" Simple plugin settings
let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }
let g:rainbow_active = 1
let g:sh_no_error = 1
let g:pymode = 1
let g:pymode_lint = 1
let g:pymode_lint_unmodified = 1
let g:pymode_lint_ignore = "E265"
let g:pymode_rope = 0
let g:pymode_doc = 1
let g:pymode_folding = 0

" Go syntax highlighting and stuff.
filetype off
filetype plugin indent off
set rtp+=$GOROOT/misc/vim
filetype plugin indent on
syntax on

" Cscope options:
set csprg=gtags-cscope
set nocsverb
cs add GTAGS
set csverb
"set cscopequickfix=s-,c+,d-,i-,t-,e-
" This one replaces tags with cscope tagging.
set cst
" Cscope shortcuts.
map <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
map <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
map <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>

" Ctrl-P options:
set wildignore+=*.tmp,*.swp,*.so,*.zip
let g:ctrlp_custom_ignore = {
     \ 'dir': '\v((\.git|\.svn)|/(orlandodocs|publicdocs|build|output))',
          \ }
          let g:ctrlp_max_files = 910000
          let g:ctrlp_use_caching = 1
          let g:ctrlp_clear_cache_on_exit = 0
          let g:ctrlp_dotfiles = 0
          let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'

" Tag searching wth CtrlP
map <C-o> :CtrlPGtags<CR>
set rtp+=$HOME/.vim/bundle/CtrlPGtags

" Vundle options:
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

" Let Vundle manage itself (required)
Bundle 'gmarik/vundle'

" My Bundles:
"
" Github repos
Bundle 'kien/ctrlp.vim'
Bundle 'klen/python-mode'
Bundle 'JazzCore/ctrlp-cmatcher'
Bundle 'rking/ag.vim'

" Gitlab repos
" Sign up to Gitlab and then comment these in!
"Bundle 'ssh://git@gitlab.datcon.co.uk/vimips.git'
"Bundle 'ssh://git@gitlab.datcon.co.uk/autocomment.git'

filetype plugin on " Required for Vundle
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..
