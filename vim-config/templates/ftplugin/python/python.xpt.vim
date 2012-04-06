XPTemplate priority=personal

let s:f = g:XPTfuncs()

" Set your python version with this variable in .vimrc or your own python
" snippet:
" XPTvar $PYTHON_EXC    /usr/bin/python
XPTvar $PYTHON_EXC    /usr/bin/env python2.6

" 3 single quotes quoted by single quote
"XPTvar $PYTHON_DOC_MARK '''''
XPTvar $PYTHON_DOC_MARK '"""'

" for python 2.5 and older
" XPTvar $PYTHON_EXP_SYM ', '
" " for python 2.6 and newer
XPTvar $PYTHON_EXP_SYM ' as '

" int fun ** (
" class name ** (
XPTvar $SPfun      ''

" int fun( ** arg ** )
" if ( ** condition ** )
" for ( ** statement ** )
" [ ** a, b ** ]
" { ** 'k' : 'v' ** }
XPTvar $SParg      ''

" if ** (
" while ** (
" for ** (
XPTvar $SPcmd      ' '

" a ** = ** a ** + ** 1
" (a, ** b, ** )
XPTvar $SPop       ' '

XPTvar $CS    #
XPTvar $CL    '"""'
XPTvar $CM    ''
XPTvar $CR    '"""'

XPT docstr wrap	" $CL$CM ..
`$CL^`$CM^`$CM^`cursor^

`$CR^
..XPT

" Redefine the default filehead template (don't want to inlcude filename since 
" it's obvious - you can see it :)
XPT filehead " file description
`$PYTHON_DOC_MARK^
Author  : `$author^
Contact : `$email^
Date    : `date()^

Description : `cursor^
`$PYTHON_DOC_MARK^
