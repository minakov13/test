Vim Configuration
=================

The configuration is designed to work on Unix-like and Windows systems out of
of the box. Make sure you have git installed (Windows users also make sure 
git is added to PATH variable and is accessible from command line). Clone the 
configuration from GitHub with::
    $ git clone git://github.com/zoresvit/vim-config.git .vim 
If you are under Unix-like system, run Vim or gVim. Vim may mention missing
packages at some point. These packages are needed for the configuration work
at full. However, Vim should work just fine without them.

Under Windows
-------------

Sometime you have to deal with Windows and it would be great to have your 
favourite Vim configuration at hand. The best way to do so without pain is to
get portable Vim from http://portableapps.com/apps/development/gvim_portable.
After unpacking gVimPortable custom configuration should be added to::
    gVimProtableDir\Data\settings\.vim\
I guess, the best way to do so is to ``cd`` into ``settings`` folder and clone
the repository::
    $ git clone git://github.com/zoresvit/vim-config.git .vim 
After that just run ``gVimProtable.exe`` and Vim configuration setup should be
all done. Do not hesitate to contact me for questions, suggestions or bug
reports (I'm sure, there are quite a few).

Compiling
=========

Debian stable repositories don't have last Vim version yet, so one would have
to build it from sources. I use the following configuration keys and commands 
when compiling Vim::
    ~$ ./configure --enable-python3interp --enable-pythoninterp --with-python3-config-dir=/usr/lib/python3.1/config --with-python-config-dir=/usr/lib/python2.6/config --enable-luainterp --enable-perlinterp --enable-tclinterp --enable-rubyinterp --enable-multibyte --with-features=huge --with-compiledby=Zoresvit --enable-gnome-check
    ~$ make
    ~$ sudo checkinstall
