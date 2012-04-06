" DESCRIPTION: Common defines for xpt
"     CREATED: 2010 Sep 17
"      AUTHOR: Zoresvit                     zoresvit@gmail.com
"              Kharkiv National University of Radio Electronics

XPTemplate priority=personal

let s:f = g:XPTfuncs()

XPTvar $author  Zoresvit
XPTvar $email   zoresvit@gmail.com

XPTvar $SPcmd      ' '
XPTvar $SPfun      ''
XPTvar $SParg      ''
XPTvar $SPop       ''

XPTvar $BRif     ' '
XPTvar $BRel     ' '
XPTvar $BRloop   ' '
XPTvar $BRstc    \n
XPTvar $BRfun    ' '

"=================== FUNCTIONS ============================
"
fun! s:f.headerSymbol(...) "{{{
  let h = expand('%:t')
  let h = substitute(h, '\.', '_', 'g') " replace . with _
  let h = substitute(h, '.', '\U\0', 'g') " make all characters upper case

  return 'SRC_'.h.'_'
endfunction "}}}

"=================== LICENSES =============================

XPT license_gpl3single " GNU GPL V3 License for single file program

`$CL^   This program is free software: you can redistribute it and/or modify
 `$CM^   it under the terms of the GNU General Public License as published by
 `$CM^   the Free Software Foundation, either version 3 of the License, or
 `$CM^   (at your option) any later version.
 `$CM^
 `$CM^   This program is distributed in the hope that it will be useful,
 `$CM^   but WITHOUT ANY WARRANTY; without even the implied warranty of
 `$CM^   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 `$CM^   GNU General Public License for more details.
 `$CM^
 `$CM^   You should have received a copy of the GNU General Public License
 `$CM^   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 `$CR^
..XPT

XPT license_gpl3multiple " GNU GPL V3 License for multiple files program

`$CL^   This file is part of `Program^.
 `$CM^
 `$CM^   `Program^ is free software: you can redistribute it and/or modify
 `$CM^   it under the terms of the GNU General Public License as published by
 `$CM^   the Free Software Foundation, either version 3 of the License, or
 `$CM^   (at your option) any later version.
 `$CM^
 `$CM^   `Program^ is distributed in the hope that it will be useful,
 `$CM^   but WITHOUT ANY WARRANTY; without even the implied warranty of
 `$CM^   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 `$CM^   GNU General Public License for more details.
 `$CM^
 `$CM^   You should have received a copy of the GNU General Public License
 `$CM^   along with `Program^.  If not, see <http://www.gnu.org/licenses/>.
 `$CR^
..XPT

XPT _d_commentDoc hidden wrap=cursor	" $CL! ..
`$CL^!
`$_xCommentMidIndent$CM^ @param `par^
`$_xCommentMidIndent$CM^ @return `value^
`$_xCommentMidIndent$CR^
..XPT

XPT dox alias=_d_commentDoc

XPT for wrap=cursor " for (..;..;++)
for`$SPcmd^(`$SParg^`^`i^`$SPop^ = `$SPop^`0^; `i^`$SPop^ < `$SPop^`len^; ++`i^`$SParg^)`$BRloop^{
    `cursor^
}

XPT once wrap	" #ifndef .. #define ..
XSET symbol=headerSymbol()
#ifndef `symbol^
#define `symbol^

`cursor^
#endif  `$CL^ `symbol^ `$CR^
