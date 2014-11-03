" Vim syntax file
" Language: vnc
" Author: Matthew Russell <matt@fredsherbet.com>

if exists("b:current_syntax")
  finish
endif

" Matches
syntax match value /[0-9a-zA-Z.]*/
syntax match field /^ *[0-9a-zA-Z.]*/
syntax match begin /^begin .*/
syntax match end /^end .*/
syntax match admin /[a-zA-Z]*[aA]dmin[a-zA-Z]*/
syntax match row /[a-zA-Z]*[rR]ow[a-zA-Z]*/
syntax match gr /1879048196/

" Highlighting
highlight red ctermfg=darkred
highlight blue ctermfg=darkblue
highlight green ctermfg=darkgreen
highlight yellow ctermfg=darkyellow
highlight pink ctermfg=darkmagenta
highlight cyan ctermfg=darkcyan
highlight link admin red
highlight link row pink
highlight link field yellow
highlight link value cyan
highlight link gr red
highlight link begin normal
highlight link end normal

let b:current_syntax = "vnc"
