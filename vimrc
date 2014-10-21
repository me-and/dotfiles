" Stop using vi-compatible settings!
set nocompatible

" Enable filetype detection, including loading filetype-specific plugins and
" indentation.
filetype plugin indent on

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

" Insert the comment leader when hitting Enter within a comment in Insert
" mode, or when hitting o/O in Normal mode.
set formatoptions+=r formatoptions+=o

" Recognize numbered lists when formatting text, using the `formatlistpat`
" option.
" TODO: Set up `formatlistpat` so it matches Markdown lists in a sensible
" fashion, possibly in a Markdown-specific ftplugin file.
set formatoptions+=n

" Look in for a tags file in the folder containing the current file, then
" recursively in parent directories until we get to `/`.
set tags=./tags;/

" Syntax higlighting is big and clever.
syntax enable

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
