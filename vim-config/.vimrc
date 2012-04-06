"   COPYRIGHT: 2012 Zoresvit (c) <zoresvit@gmail.com>
" DESCRIPTION: Vim resource configuration.


" Define Vim user directory.
if has('unix')
    let $MYVIM=$HOME . '/.vim'
endif
if has('win32') || has('win64')
    " Dirtiest hack to get vim directory under gVimPortable.exe.
    let $MYVIM=getcwd()
    let $MYVIM=$MYVIM . '\Data\settings\.vim\'
endif


" VUNDLE
" ======

filetype off

if !isdirectory($MYVIM . "/bundle")
    call mkdir($MYVIM . "/bundle", "p")
    cd $MYVIM/bundle
    if executable('git')
        !git clone https://github.com/gmarik/vundle.git
        call BundleInstall!
    else
        echo 'WARNING: Git is missing! Cannot pull vundle plugin.'
    endif
endif
set rtp+=$MYVIM/bundle/vundle/
call vundle#rc()

" Plugin management
" ------------------
" git clone https://github.com/gmarik/vundle.git vundle
Bundle 'gmarik/vundle'
Bundle 'drmingdrmer/xptemplate'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/nerdcommenter'
Bundle 'tpope/vim-surround'
Bundle 'altercation/vim-colors-solarized'
Bundle 'skwp/vim-conque'
if has('unix')
    if executable('ctags')
        Bundle 'vim-scripts/taglist.vim'
    else
        echo 'Need exuberant-ctags for taglist.vim plugin!'
    endif
    if executable('clang')
        Bundle 'Rip-Rip/clang_complete'
    else
        echo 'Need clang with llvm for clang_complete plugin!'
    endif
endif


" VIM OPTIONS
" ===========

" For the meaning and possible values of each option look up :help option.
if has('win32') || has('win64')
    behave mswin
endif

filetype plugin indent on
syntax on
set nocompatible  " Enable Vim awesome features, get rid of Vi compatibility.

" Behavior
" --------
set vb  " Beeping in text editor is useless and stupid.
set t_vb=  " See ":help vb" for more details on option usage.
" Flashing is even more annoying, disable it.
set backspace=indent,eol,start
set scrolloff=3
set sidescrolloff=15
set hidden
set autochdir
set diffopt+=iwhite
set autoread
set foldlevelstart=99
set backup
set path+=.,,** " search for files recursively (http://www.allaboutvim.ru/2012/03/blog-post.html)
if !isdirectory($MYVIM . "/backups")
    call mkdir($MYVIM . "/backups", "p")
endif
set backupdir=$MYVIM/backups
set undofile
set undodir=$MYVIM/backups
if !isdirectory($MYVIM . "/swap")
    call mkdir($MYVIM . "/swap", "p")
endif
set directory=$MYVIM/swap
set fileformats=unix,dos,mac
set completeopt=menuone,longest
set fileencodings=utf-8,windows-1251,iso-8859-15,koi8-r,latin1
let g:tex_flavor = "latex"
" Close omni-completion preview window when entering or leaving insert mode.
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" Editing
" -------
" Open useful cheats and hints on vim usage in new window.
command! Cheat sp $MYVIM/cheats.txt
" Enable command for processing binary files.
command! -bar Hex call ToggleHex()
set browsedir=current
set undolevels=2048
set history=1024
set virtualedit=all
set showmode
set showcmd
set listchars=tab:->,trail:-
set splitbelow
set splitright
set lazyredraw
set wildmenu
set nowrap
set spelllang=en,ru_yo,uk
set spellsuggest=10
set mousehide
set timeoutlen=300
" Search
" ~~~~~~
set incsearch
set ignorecase
set smartcase
set nowrapscan
set hlsearch

" Appearance
" ----------
set fillchars=  " Get rid of characters in windows separators.
set cursorline
set number
set laststatus=2  " Always show status line.
set statusline=%f\ %m\ %r\ %y\ [%{&fileencoding}]\ [len\ %L:%p%%]
set statusline+=\ [pos\ %02l:%02c\ 0x%O]\ [chr\ %3b\ 0x%02B]\ [buf\ #%n]
set cursorcolumn
set colorcolumn=80
set background=dark
" Using vim-solarized colorscheme. So it's settings are in PLUGINS section.

" Syntax
" ------
set synmaxcol=2048
set showfulltag
set matchpairs+=<:>
" Indentation
" ~~~~~~~~~~~
" Good explanation of indent options: http://tedlogan.com/techblog3.html
set autoindent
set tabstop=4  " How many columns a tab counts for. Affects existing text.
set expandtab  " Insert spaces instead of tabs.
set shiftwidth=4  " Number of columns to indent with << and >> operations.
set softtabstop=4  " Always insert spaces instead of tabs if expandtab is set.
set smarttab


" PLUGINS CONFIGURATION
" =====================

" xptemplate
" ----------
" Autoclosing brackets is turned off by default since issue 22:
" (http://code.google.com/p/xptemplate/issues/detail?id=22#c0).
let g:xptemplate_brace_complete = '([{<"'
set rtp+=$MYVIM/templates/

if has('unix')
    " clang_complete
    " --------------
    let g:clang_use_library=1
    let g:clang_library_path='/usr/local/lib'
    let g:clang_exec='/usr/local/bin/clang'
    let g:clang_hl_errors=1
    let g:clang_complete_copen=1
    let g:clang_periodic_quickfix=0
    autocmd Filetype c,cpp,cxx,h,hxx autocmd BufWritePre <buffer> :call g:ClangUpdateQuickFix()

    " TagList
    " -------
    nnoremap <silent> <F3> :TlistToggle<CR>
endif

" NERDTree
" --------
imap <F2> :NERDTreeToggle<CR>
nmap <F2> :NERDTreeToggle<CR>

" SOLARIZED
" ---------
let g:solarized_bold=0
let g:solarized_underline=0
let g:solarized_italic=0
let g:solarized_hitrail=1
" 16 colors are supported by most terminals and it's enough for solarized.
set t_Co=16
colorscheme solarized


" MAPPINGS
" ========

" Default <leader> is \ (backslash). It may be redefined:
"let mapleader = ","
" Note: (from :help CTRL-[)
" If your <Esc> key is hard to hit on your keyboard, train yourself to use 
" CTRL-[.

" Most of the time comma should be followed by a space.
inoremap , ,<SPACE>
" Shortcuts for editing configuration files.
nmap <silent> <leader>v :sp $MYVIMRC<CR>
nmap <silent> <leader>g :sp $MYGVIMRC<CR>
nmap <leader>V :source $MYVIMRC<CR>
nmap <leader>G :source $MYGVIMRC<CR>
" Restore last session.
nmap <leader>ls :call LoadSession()<CR>
" Toggle check spelling.
nmap <leader>s :set spell!<CR>
" Spell fix. Chooses the first match from spelling suggestions.
imap <silent> <leader>sf <ESC>1z=ea
nmap <silent> <leader>sf <ESC>1z=ea
" Switch to last edited buffer.
noremap <silent> <leader>bl :b#<CR>
" Buffer navigation (next/previous).
noremap <silent> <leader>bn :bn<CR>
noremap <silent> <leader>bp :bp<CR>
" Open/close quick fix window
nmap <silent> <leader>q :copen<CR>
nmap <silent> <leader>qq :cclose<CR>
" Compile errors navigation in quickfix.
noremap <silent> <leader>en :cn<CR>
noremap <silent> <leader>ep :cp<CR>
" Map the placeholder <+ +> navigation
nnoremap <silent> <C-j> /<+.\{-1,}+><CR>c/+>/e<CR>
inoremap <silent> <C-j> <ESC>/<+.\{-1,}+><CR>c/+>/e<CR>
" Make the current file executable.
nmap <leader>x :w<CR>:!chmod 755 %<CR>:e<CR><CR>
" Remove trailing spaces (http://vim.wikia.com/wiki/Remove_unwanted_spaces).
nnoremap <silent><F9> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>
" Enable to russian layout
inoremap <leader>ru <ESC>:set keymap=russian-jcukenwin<CR>a
nnoremap <leader>ru :set keymap=russian-jcukenwin<CR>
" Change to ukrainian layout
inoremap <leader>ua <ESC>:set keymap=ukrainian-jcuken<CR>a
nnoremap <leader>ua :set keymap=ukrainian-jcuken<CR>
" Change to hebrew layout
inoremap <leader>he <ESC>:set keymap=hebrew_utf-8<CR>a
nnoremap <leader>he :set keymap=hebrew_utf-8<CR>


" AUTOCOMMANDS
" ============

augroup COMMON
    au!
    au FileType * set textwidth=79
    au BufReadPre *.txt,*.rst set spell
    " Insert predefined file boilerplate on creation.
    au BufNewFile * silent! 0r $MYVIM/boilerplates/%:e.tpl
    " Enable quickfix window height adjustment.
    au FileType qf call AdjustWindowHeight(3, 6)
    au VimLeave * call SaveSession()
    " Navigate line by line in wrapped text (skip wrapped lines).
    au BufReadPre * imap <UP> <ESC>gka
    au BufReadPre * imap <DOWN> <ESC>gja
    " Navigate row by row in wrapped text.
    au BufReadPre * nmap k gk
    au BufReadPre * nmap j gj
augroup END

augroup SOURCES
    au!
    au BufReadPre * set completeopt=menuone,longest
    au BufReadPre * set textwidth=79
    au BufReadPre *.tex map <F5> :make <CR>
augroup END

augroup CLIKE
    " Search for Makefile or SConstruct and perform build.
    au FileType c,cpp map <F6> :call Compile()<CR>
    " Check current file for correspondence to Google Style Guide with cpplint tool
    au FileType c,cpp nmap <F8> :set makeprg=$MYVIM/cpplint.py\ %<CR>:make<CR>:copen<CR><CR>
augroup END

augroup PYTHON
    au!
    au FileType python set completeopt=menuone,longest,preview
    " Check Python PEP8 code style compliance (depends on pep8) 
    if executable('pep8')
        au FileType python nmap <F8> :set makeprg=pep8\ --show-source\ --show-pep8\ %<CR>:make<cr>:copen<CR><CR>
    else
        echo 'Need pep8 installed for Python code style checking.'
    endif
augroup END

augroup SAGE
    au!
    autocmd BufRead,BufNewFile *.sage set filetype=python
    autocmd BufRead,BufNewFile *.sage set syntax=sage
    autocmd BufRead,BufNewFile *.sage set makeprg=sage\ -b\ &&\ sage\ -t\ %
augroup END

augroup LATEX
    au!
    au FileType tex set makeprg=make\ -f\ $MYVIM/texMakefile\ TARGET=%
    au FileType tex map <F5> :make -B <CR>
    if executable('okular')
        let $TEXTARGET=substitute(@%, ".tex", ".pdf", "")
        au BufReadPre *.tex nmap <F7> :!okular $TEXTARGET & <CR><CR>
    else
        echo 'WARNING: PDF viewer is missing!'
    endif
augroup END

augroup BIN
    au!
    au BufWritePre * if exists("b:editHex") && b:editHex==1 | call ToggleHex() | endif
    au BufWritePost * if exists("b:editHex") && b:editHex==0 | call ToggleHex() | endif
augroup END


" FUNCTIONS
" =========

" Helper function for processing binary files via hex editor.
function! ToggleHex()
    " Hex mode should be considered a read-only operation
    " save values for modified and read-only for restoration later,
    " and clear the read-only flag for now.
    let l:modified=&mod
    let l:oldreadonly=&readonly
    let &readonly=0
    let l:oldmodifiable=&modifiable
    let &modifiable=1
    if !exists("b:editHex") || !b:editHex
        " save old options
        let b:oldft=&ft
        let b:oldbin=&bin
        " set new options
        setlocal binary " make sure it overrides any textwidth, etc.
        let &ft="xxd"
        " set status
        let b:editHex=1
        " switch to hex editor
        %!xxd
    else
        " restore old options
        let &ft=b:oldft
        if !b:oldbin
            setlocal nobinary
        endif
        " set status
        let b:editHex=0
        " return to normal editing
        %!xxd -r
    endif
    " restore values for modified and read only state
    let &mod=l:modified
    let &readonly=l:oldreadonly
    let &modifiable=l:oldmodifiable
endfunction

" Adjust QuickFix window height according to the number of data lines.
function! AdjustWindowHeight(minheight, maxheight)
    exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

" Save current vim session.
function! SaveSession()
    execute 'mksession! $MYVIM/session.vim'
endfunction

" Load last vim session
function! LoadSession()
    if argc() == 0
        execute 'source $MYVIM/session.vim'
    endif
endfunction

" Recursively look for Makefile or SConstruct and perform build accordingly.
function! Compile()
    let origcurdir = getcwd()
    let curdir     = origcurdir
    while curdir != "/"
        if filereadable("Makefile")
            break
        elseif filereadable("SConstruct")
            break
        endif
        cd ..
        let curdir= getcwd()
    endwhile
    if filereadable('Makefile')
        set makeprg=make
    elseif filereadable('SConstruct')
        set makeprg=scons
    else
        set makeprg=make
    endif
    echo "now building..."
    silent w
    make
    echo "build finished"
endfunction

