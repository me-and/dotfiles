" Language: SLOTH trace files (sbc_logging.py)
" Maintainer: Thomas Lee (TAL)

if exists("b:current_syntax")
  finish
endif
syntax clear

" Specific matches -- files
syn match perimeta   /^perimeta.py .*MainThread[^:]*: /
syn match craft      /^craft.py .*MainThread[^:]*: /
syn match session    /^session.py .*MainThread[^:]*: /
syn match cli        /^cli.py .*MainThread[^:]*: /
syn match controller /^controller.py .*MainThread[^:]*: /

" Specific matches -- logs
syn match error    /^.* ERROR     : /
syn match warning  /^.* WARNING   : /

" Highlighting
highlight per ctermbg=darkgreen
highlight cra ctermbg=darkblue
highlight ses ctermbg=darkmagenta
highlight cli ctermbg=darkcyan
highlight con ctermbg=darkyellow

" Link matches to highlighting
highlight link perimeta   per
highlight link craft      cra
highlight link session    ses
highlight link cli        cli
highlight link controller con

let b:current_syntax = "sloth"
