"================================================================= 
" DESCRIPTION: Latex templates
"     CREATED: 2010 Oct 25
"      AUTHOR: Zoresvit                     zoresvit@gmail.com
"              Kharkiv National University of Radioelectronics
"=================================================================

XPTemplate priority=personal+

let g:tex_flavor = "latex"
let s:f = g:XPTfuncs()

XPTvar $SParg      ''
XPTvar $SPcmd      ''
XPTvar $SPop       ''

" ========================= Function and Variables =============================


" ================================= Snippets ===================================

XPT eq " \\begin{equation} .. \\end{equation}
\begin{equation}
\label{eqn:`label^}
`cursor^
\end{equation}
..XPT

XPT figure  " floating figure
\begin{figure}[`htbp^]
	\centering
	\includegraphics[scale=`1^]{`obj^}
	\caption{`caption^}
	\label{fig:`label^}
\end{figure}
..XPT

XPT tablef  " floating table
\begin{table}[`htbp^]
\centering
\caption{`caption^}
\label{tbl:`label^}
`cursor^
\end{table}
..XPT

XPT eqarray " equation array
\begin{equation}
`value^ = \left\{
	\begin{array}{ll}
		`condition1^	\\
		`condition2^
	\end{array} \right.
\end{equation}
..XPT

XPT subsection " subsection
\subsection{`title^}
\label{sec:`label^}
..XPT

XPT subsubsection " subsubsection
\subsection{`title^}
\label{sec:`label^}
..XPT

XPT v " inline verbatim
\verb+`key^+`^
..XPT

XPT verbatim " verbatim environment
\begin{verbatim}
`cursor^
\end{verbatim}
..XPT

XPT emph " emphasize text
\emph{`^}
..XPT

XPT listing " listing encironment
\begin{lstlisting}[label=lst:`label^, caption=`caption^`...{{^, `set^=`value^`...^`}}^]
`cursor^
\end{lstlisting}

XPT frame " \begin{frame}{..} .. \end{frame}
\begin{frame}[label=`label^]{`title^}
    `cursor^
\end{frame}

XPT usepackage " \usepackage{...}
\usepackage`[optional]^{`package^}
..XPT

XPT requirepack " \RequirePackage{...}
\RequirePackage`^{`package^}
..XPT

XPT preambule " \documentclass[...]{...}
\documentclass`[a4paper, 12pt]^{`article^}

\begin{document}
`cursor^
\end{document}
..XPT

XPT pdfinfo " \hypersetup for pdf meta info
\hypersetup{
    pdftitle = {`title^}, 
    pdfauthor = {`author^}, 
    pdfsubject = {`subject^}, 
    pdfkeywords = {`keywords^}
}

XPT title " Title and author data
\author`[mini_author]^{\texorpdfstring{`author^\\[2ex]
\scriptsize\url{`email^}}{Author}}
\title`[mini_title]^{`title^}
\subtitle{`subtitle^}
\institute`[mini_inst]^{`institution^}
\date{`date^}
..XPT
