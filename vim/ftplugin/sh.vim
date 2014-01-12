" Bash's `type` builtin formats things using four space indents, so follow
" that lead.
set expandtab
set tabstop=4

" Only need to set shiftwidth and softtabstop on Vim 7.3 or later; it'll be
" automatically set in vimrc to match tabstop on Vim 7.4.
if version < 704
	set shiftwidth=4
	set softtabstop=4
endif

" Mark whitespace.
set list listchars=tab:>\ ,trail:-
