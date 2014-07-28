" PEP8 says indent with four spaces per indentation level.
set expandtab
set shiftwidth=4

" Only need to set softtabstop on Vim 7.3 or later; it'll be automatically set
" in vimrc to match tabstop on Vim 7.4.
if version < 704
	set softtabstop=4
endif

" Nonetheless, we may see files with tabs.  The interpreter considers those as
" being aligned at eight spaces.
set tabstop=8

" Mark whitespace.
set list listchars=tab:>\ ,trail:-

" Highlight line end
set colorcolumn=80
