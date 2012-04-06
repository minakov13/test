" ========================================
" Zoresvit's personal XPTemplate settings
"
" All changes to original XPTemplate plugin should be defined in ~/.vim/personal/ folder
" ========================================

XPTemplate priority=personal+

let s:f = g:XPTfuncs()

XPTvar $SPcmd      ' '
XPTvar $SPfun      ''
XPTvar $SParg      ''
XPTvar $SPop       ''

XPTvar $BRif     ' '
XPTvar $BRel     ' '
XPTvar $BRloop   ' '
XPTvar $BRstc    \n
XPTvar $BRfun    ' '

XPTinclude
      \ _common/common

" ================= Redefined Function and Variables =============================

fun! s:f.c_fun_type_indent()
       return ""
endfunction

fun! s:f.c_fun_body_indent()
        return " "
endfunction

" ===================== Redefined Snippets ===================================

XPT once wrap=cursor	" #ifndef .. #define ..
XSET symbol=headerSymbol()
XSET symbol|post=UpperCase(V())
#ifndef `symbol^
#define `symbol^

`cursor^                   

#endif `$CL^ `symbol^ `$CR^

XPT fun wrap=cursor	hint=func..\ (\ ..\ )\ {...
`c_fun_type_indent()^`int^`c_fun_body_indent()^`name^(`...^`param^`...^)`$BRfun^{
    `cursor^
}

XPT #inc    " include <>
#include <`^>

XPT #inch    " include ""
#include "`^.h"

XPT memcpy " memcpy (..., ..., sizeof (...) ... )
memcpy(`dest^, `source^, sizeof(`type^int^) * `count^)

XPT memset " memset (..., ..., sizeof (...) ... )
memset(`buffer^, `what^0^, sizeof( `type^int^ ) * `count^)

XPT malloc " malloc ( ... );
(`type^int^*) malloc(sizeof(`type^) * `count^)

XPT else wrap=cursor " else { ... }
else`$BRif^{
    `action^
}
`cursor^

XPT switch wrap=cursor	" switch (..) {case..}
switch(`$SParg^`var^`$SParg^)`$BRif^{
    `Include:case^`...^
    `Include:case^`...^
    default:
        `cursor^
}
..XPT

XPT case wrap=cursor	" case ..:
case `constant^`$SPcmd^:
    `action^
    break;

XPT main hint=main\ (argc,\ argv)
`c_fun_type_indent()^int`c_fun_body_indent()^main(int argc, char** argv)`$BRfun^{
    `cursor^
    return 0;
}
..XPT

XPT commentDoxInline " Doxygen C comment line
  `$CL^*< `cursor^ `$CR^
..XPT

XPT fheader " File header
/*
 * Copyright 2011 Zoresvit (c) <zoresvit@gmail.com>
 *
 * `description^
 */

`cursor^
 ..XPT
