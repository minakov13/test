"================================================================= 
" DESCRIPTION: C++ templates
"     CREATED: 2010 Sep 17
"      AUTHOR: Zoresvit                     zoresvit@gmail.com
"              Kharkiv National University of Radioelectronics
"=================================================================

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

" ========================== Redefined Snippets ===================================

XPT class   " class ..
class `className^ {
 public:
    `className^(`ctorParam^);
    `className^(const `className^ &cpy);
    ~`className^();

    `cursor^
 protected:
    `pretected^ 
 private:
    `private^
}`^;
..XPT


XPT try wrap=what " try .. catch..
try {
    `what^
}`$BRel^`Include:catch^


XPT catch " catch\( .. )
catch(`except^) {
    `cursor^
}


XPT commentDoxInline " Doxygen C++ comment line
  ///< `^
..XPT

XPT switch wrap	" switch (..) {case..}
switch (`$SParg^`var^`$SParg^)`$BRif^{
    `Include:case^
}
..XPT

XPT case wrap	" case ..:
case `constant^`$SPcmd^:
    `cursor^
    break;
