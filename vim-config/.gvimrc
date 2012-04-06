set columns=81  " Set number of columns in VIM window
set lines=40  " Set number of lines in VIM window

" Set up the gui cursor look nice
set guicursor=n-v-c:block-Cursor-blinkon0
set guicursor+=ve:ver35-Cursor
set guicursor+=o:hor50-Cursor
set guicursor+=i-ci:ver25-Cursor
set guicursor+=r-cr:hor20-Cursor
set guicursor+=sm:block-Cursor-blinkwait175-blinkoff150-blinkon175
set t_vb=  " Reset visual bell value again.

if has('unix')
    set guifont=Monospace\ 12
    set guioptions=ca  " Get rid of toolbars and menues
endif

if has('win32') || has('win64')
    set guifont=Consolas:h12
endif
