" Vim syntax file
" Language: audit
" Author: Matthew Russell <matt@fredsherbet.com>

if exists("b:current_syntax")
  finish
endif

" Matches
syntax match run /Run script/
syntax match stopstart /vp3stop\|vp3start\|vp3reboot/
syntax match gr /[a-zA-Z0-9_-]*cluster[a-zA-Z0-9_-]*/
syntax match upgrade /[a-zA-Z0-9_-]*upg[a-zA-Z0-9_-]*/

" Highlighting
highlight red ctermfg=red
highlight blue ctermfg=blue
highlight green ctermfg=darkgreen
highlight yellow ctermfg=darkyellow
highlight Comment ctermfg=darkcyan
"highlight link debug Comment
highlight link run yellow
highlight link stopstart red
highlight link gr green
highlight link upgrade red

let b:current_syntax = "audit"
