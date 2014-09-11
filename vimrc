" Stop using vi-compatible settings!
set nocompatible

" Keep using the current indent level when starting a new line.
set autoindent

" Make backspace useful.
set backspace=indent,eol,start

" Always have a status line and the current position in the file.
set laststatus=2
set ruler

" Show details of selected text when selecting it.
set showcmd

" Use incremental search.
set incsearch

" Tab completion of Vim commands.
set wildmenu
set wildmode=longest,list

" Put the relative line number in the margin.
set relativenumber
highlight LineNr ctermfg=gray

" Allow toggling between relative numbers and absolute line numbers by
" pressing ^N.
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

" Show whitespace in a useful fashion.  Note this disables the `linebreak`
" setting, so to `set linebreak` you'll also need to `set nolist`.
set list listchars=tab:\ \ ,trail:-

" When entering a bracket, show its partner.
set showmatch

" If using the spell checker, we're writing in British English.
set spelllang=en_gb

" If we support it (added in Vim 7.4), have the value of shiftwidth follow
" that of tabstop, and the value of softtabstop follow shiftwidth.
if version >= 704
	set shiftwidth=0
	set softtabstop=-1
endif

" Search for selected text, forwards or backwards (taken from
" <http://vim.wikia.com/wiki/Search_for_visually_selected_text>).
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

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
