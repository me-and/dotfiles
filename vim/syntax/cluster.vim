" Vim syntax file
" Language: cluster
" Author: Matthew Russell <matt@fredsherbet.com>

if exists("b:current_syntax")
  finish
endif

" Matches
syntax match preamble /^.\{-\} - /
"syntax match debug /.*DEBUG.*/
syntax match info /INFO/
syntax match data /DATA/
syntax match init /INIT/
syntax match resync /RESYNC_STARTED\|RESYNC_NOT_POSSIBLE\|RESYNC\|RECOVERY_DONE\|RECOVER/
syntax match state /New view\|new leader is/
syntax match mergeview /MergeView/
syntax match changeid /ChangeId([^)]*)/
syntax match starting /.*starting.*/

" Highlighting
highlight red ctermfg=red
highlight blue ctermfg=blue
highlight green ctermfg=darkgreen
highlight yellow ctermfg=darkyellow
highlight Comment ctermfg=darkcyan
"highlight link debug Comment
highlight link info red
highlight link preamble Comment
highlight link init red
highlight link data blue
highlight link resync blue
highlight link state green
highlight link mergeview red
highlight link changeid yellow
highlight link starting red

let b:current_syntax = "cluster"
