" clear any existing autocommands:
autocmd!

" -----------------------------------------------------------------------------
" Basic settings
" -----------------------------------------------------------------------------

set shortmess=at                    " no startup message
set modeline                        " read vim settings in the comments of files
set nocompatible                    " don't make compatible with vi
set term=xterm-256color             " 256 color vim :)
set backspace=eol,start,indent      " backspace behaviour
set cindent                         " programmers autoindent, and dont remove indent on '#':
set cinkeys-=0#
set indentkeys-=0#
set shiftwidth=4
set softtabstop=4                   " tab is 4 spaces in insert mode
set tabstop=4                       " tab is 4 spaces
set expandtab                       " turn tabs into spaces
set nohidden                        " 'set hidden' : enable unsaved buffer switching
set sidescroll=1                    " move window by 1 while scrolling
set sidescrolloff=10                " horizontal area around cursor
set scrolloff=10                    " vertical area around cursor
set history=50                      " default: 20. command history
set wildmode=list:longest,full      " have command-line completion <Tab>
set wildignore=*.o,*~,*.pyc,.git\*,.hg\*,.svn\*  " ignore compiled files
set showmode                        " display the current mode and partially-typed commands in the status line
set noshowcmd                         " Show (partial) command in the last line of the screen.
set wildignorecase                  " case insensitive on filename completion
set hlsearch                        " highlight search matches
set ignorecase                      " ignore case during search
set smartcase                       " Override the 'ignorecase' option if the search pattern contains upper case characters.
set incsearch                       " match pattern while typing search
set spelllang=en_us                 " set language
set virtualedit=all                 " let cursor go beyond end of line (set to default: 'set ve=')
set number                          " show line numbers
set textwidth=0                     " wrapping options: text width is terminal width
set wrapmargin=0
set nowrap
set nolinebreak
set nolist
set shell=/bin/bash
set fillchars="vert: "              " remove vertical split separator
set autoread                        " auto read when file changes from external source
"set colorcolumn=80                 " indicator for line width
set encoding=utf8                   " set utf8 as standard encoding
let mapleader=","                   " we can now use <leader> for additional key combinations
set ffs=unix                        " use unix as the standard file type
set splitbelow                      " new split open below
set splitright                      " new split open to the right
set noequalalways                   " dont resize splits when creating a new one
set shortmess+=I                    " no startup message on empty file
set nostartofline                   " dont jump to first non-blank chararcter on line
set magic                           " use regular expressions

set nofoldenable                      " disable folding
set foldlevelstart=99                 " disable folding
set diffopt+=context:99999            " disable folding
let g:vim_markdown_folding_disabled=1 " disable folding

syntax on                           " syntax highlighting

" generate ctags from anywhere in source tree
set tags=tags;/

" reduce timeout
set timeout
set timeoutlen=500
set ttimeout
set ttimeoutlen=100

set ttyfast                         " smooth redrawing on fast terminals
set lazyredraw                      " fix slow scrolling on some files
autocmd VimEnter * redraw!          " redraw is necessary because of startup bug with 'set lazyredraw'

if &diff
    autocmd VimResized * wincmd =
endif

" better encryption, activate with :X<CR>
set cryptmethod=blowfish

" no visual bell
set visualbell t_vb=

" -----------------------------------------------------------------------------
" Statusline appearance
" -----------------------------------------------------------------------------

set laststatus=2
set statusline=
set statusline +=\ %y       " file type
set statusline +=\ %f       " filename
set statusline +=\ %m       " modified marker
set statusline +=%=         " right align
set statusline +=\ %v       " virtual column
set statusline +=\ %l/%L    " row/total rows
set statusline +=\ %P       " location

set ruler
set rulerformat =%=
set rulerformat +=\ %v      " virtual column
set rulerformat +=\ %l/%L   " row/total rows
set rulerformat +=\ %P       " location

" -----------------------------------------------------------------------------
" Setup directories
" -----------------------------------------------------------------------------

if $VIMDIR == "" | if exists("*mkdir")

    let $VIMDIR=expand("$HOME/.vim")
    let $TMPDIR=expand("$VIMDIR/tmp")
    " set runtimepath=$VIMDIR

    let &directory=expand("$TMPDIR/swap")

    set undofile                        " Maintain undo history between sessions
    let &undodir=expand("$TMPDIR/undo")
    set undolevels=1000000              " default: 1000. set maximum undos.

    set backup
    let &backupdir=expand("$TMPDIR/backup")
    set backupext=.bak

    let &viewdir=expand("$TMPDIR/viewdir")

    if !isdirectory(expand("$VIMDIR"))|call mkdir(expand("$VIMDIR"), "p", 0700)|endif
    if !isdirectory(expand("$VIMDIR/bundle"))|call mkdir(expand("$VIMDIR/bundle"), "p", 0700)|endif
    if !isdirectory(expand("$TMPDIR"))|call mkdir(expand("$TMPDIR"), "p", 0700)|endif
    if !isdirectory(expand(&viewdir))| call mkdir(expand(&viewdir), "p", 0700) |endif
    if !isdirectory(expand(&directory))| call mkdir(expand(&directory), "p", 0700) |endif
    if !isdirectory(expand(&backupdir))|call mkdir(expand(&backupdir), "p", 0700)|endif
    if !isdirectory(expand(&undodir))| call mkdir(expand(&undodir), "p", 0700)|endif
    autocmd VimLeave * if filereadable(expand("$VIMDIR/.netrwhist"))|call delete(expand("$VIMDIR/.netrwhist"))|endif
else
    set noundofile                      " don't maintain undos between sessions
    set nobackup                        " no backup files
    set nowritebackup                   " don't backup file while editing
    echoerr "Unable to create runtime directories.."
endif | endif

" -----------------------------------------------------------------------------
" Plugin configurations
" -----------------------------------------------------------------------------

set nocompatible  " be iMproved, required
filetype off      " required

if !filereadable(expand("~/.vim/bundle/Vundle.vim/autoload/vundle.vim"))
    try
        silent! execute "silent !git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim"
        let g:install_plugins=1
    catch
    endtry
endif

if filereadable(expand("~/.vim/bundle/Vundle.vim/autoload/vundle.vim"))
    " let Vundle manage plugins. Brief help:
    "
    " :PluginList       - lists configured plugins
    " :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
    " :PluginSearch foo - searches for foo; append `!` to refresh local cache
    " :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
    Plugin 'VundleVim/Vundle.vim'


    Plugin 'rhysd/vim-grammarous'
    Plugin 'vim-scripts/VisIncr'
    Plugin 'vim-scripts/Syntastic'
    Plugin 'kien/rainbow_parentheses.vim'
    Plugin 'scrooloose/syntastic'
    Plugin 'chrisbra/Recover.vim'
    Plugin 'altercation/vim-colors-solarized'
    Plugin 'jezcope/vim-breakindent'
    Plugin 'derekwyatt/vim-scala'

    " Git plugin not hosted on GitHub
    "Plugin 'git://<url>/<repository>'
    " git repos on your local machine (i.e. when working on your own plugin)
    "Plugin 'file:///home/.vim/bundle/<plugin>'

    call vundle#end()
    if exists('g:install_plugins')
        execute ':PluginInstall'
    endif

    " synctastic configuration
    let g:syntastic_cpp_config_file = '.syntastic_cpp_config'
    let g:syntastic_enable_signs=1
    let g:syntastic_cpp_include_dirs = [$HOME.'/programs/include', 'usr/include', 'include', '../include', '../../include', '../../../include' ]
    let g:syntastic_cpp_check_header = 1
    let g:syntastic_cpp_remove_include_errors = 1
    let g:syntastic_cpp_compiler_options = ' -std=c++0x'
    let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
    nnoremap <C-w>E :SyntasticToggleMode<CR>

    " plugin: ctrl-P
    " let g:ctrlp_map = '<c-p>'
endif

" -----------------------------------------------------------------------------
" Show filename of currently focussed file in the tmux statusbar
" -----------------------------------------------------------------------------

" alternative 1: print filename to terminal title and use #T in tmux
set title                           " set terminal title to current open file
autocmd BufEnter * let &titlestring = ' ' . expand("%:t")  " set terminal title

" alternative 2: print filename to tmux environment variable
"autocmd BufEnter *
"    \ silent execute '!
"    \ if [ -n "$TMUX" ]; then
"    \     tmux set-environment TMUX_STATUS_$(tmux display -p "\#S_\#I") '.expand('%:t').';
"    \     tmux refresh-client -S;
"    \ fi;'
"autocmd VimLeave *
"    \ silent execute '!
"    \ if [ -n "$TMUX" ]; then
"    \     tmux set-environment TMUX_STATUS_$(tmux display -p "\#S_\#I") "";
"    \     tmux refresh-client -S;
"    \ fi;'

" -----------------------------------------------------------------------------
" Filetype settings
" -----------------------------------------------------------------------------

filetype plugin on
filetype indent on

augroup filetype
    autocmd BufNewFile,BufRead *.th set filetype=cpp
    autocmd BufNewFile,BufRead *.cu set filetype=cu
    autocmd BufNewFile,BufRead Makefile set filetype=make
augroup end

autocmd FileType tcc,c,cpp,cc,sh setlocal cindent nowrap | syntax keyword cTodo NOTE
autocmd FileType make setlocal noexpandtab shiftwidth=4
autocmd FileType tex,txt setlocal wrap linebreak noai nocin nosi inde=
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o " disable auto commenting

" -----------------------------------------------------------------------------
" User functions and trics
" -----------------------------------------------------------------------------

" quickly ROT13 your buffer:
nmap <C-w>X ggg?G``

" resize windows on terminal resize
autocmd VimResized * :wincmd =

" make cursor stay put when leaving edit mode
let CursorColumnI = 0 "the cursor column position in INSERT
autocmd InsertEnter * let CursorColumnI = col('.')
autocmd CursorMovedI * let CursorColumnI = col('.')
autocmd InsertLeave * if col('.') != CursorColumnI | call cursor(0, col('.')+1) | endif

" toggle maximization of buffer in split screen with <c-w>m
nnoremap <C-W>m :call MaximizeToggle()<CR>
nnoremap <C-W><C-m> :call MaximizeToggle()<CR>
function! MaximizeToggle()
    if exists("s:maximize_session")
        exec "source " . s:maximize_session
        call delete(s:maximize_session)
        unlet s:maximize_session
        let &hidden=s:maximize_hidden_save
        unlet s:maximize_hidden_save
    else
        let s:maximize_hidden_save = &hidden
        let s:maximize_session = tempname()
        set hidden
        exec "mksession! " . s:maximize_session
        only
    endif
endfunction

" remove trailing white space on write
autocmd BufWritePre * :%s/\s\+$//e

" make pretty columns in visual mode
vnoremap t !column -t<CR>

" remove newline and add space
vnoremap n :-1s/\n/\ /g<CR>

" reload configuration
nnoremap <C-w>r :source ~/.vimrc<CR>
" print current file
ca lpr execute ':!lpr -o sides=two-sided-long-edge -o number-up=2 '.expand('%:p')<CR>

" search will center on target found
nnoremap N Nzz
nnoremap n nzz

" why press SHIFT all the time?
nnoremap ; :

" command aliases
cnoreabbrev hs split

" quick window resize
nnoremap <silent> <C-w>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <C-w>- :exe "resize " . (winheight(0) * 2/3)<CR>
nnoremap <silent> <C-w>> :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
nnoremap <silent> <C-w>< :exe "vertical resize " . (winwidth(0) * 2/3)<CR>

nnoremap <silent> <C-w>H <C-w>H<C-w>=
nnoremap <silent> <C-w>J <C-w>J<C-w>=
nnoremap <silent> <C-w>K <C-w>K<C-w>=
nnoremap <silent> <C-w>L <C-w>L<C-w>=
" -----------------------------------------------------------------------------
" Navigational changes and aliases
" -----------------------------------------------------------------------------

" have the h and l cursor keys wrap between lines (like <Space> and <BkSpc> do
" by default), and ~ covert case over line breaks; also have the cursor keys
" wrap in insert mode:
set whichwrap=h,l,~,[,]

ca W w
ca Q q
ca A a
ca WQ wq
ca WQA wqa

" navigational keybindings

inoremap <C-k> <Esc>gki
inoremap <C-j> <Esc>gji
inoremap <C-l> <Right>
inoremap <C-h> <Left>
inoremap <C-r> <Esc>g_a
inoremap <C-e> <Esc>^i
inoremap <C-u> <BS>
inoremap <C-o> <Del><Esc>i
inoremap <C-f> <Esc>

nnoremap I i
nnoremap i <Esc>i
nnoremap L 4zl
nnoremap H 4zh
nnoremap <silent> K 2gk2
nnoremap <silent> J 2gj2
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <C-k> gk
nnoremap <C-j> gj
nnoremap <C-l> <Right>
nnoremap <C-h> <Left>
nnoremap <C-r> g_
nnoremap <C-e> ^
nnoremap <C-q> <C-e>
nnoremap <C-u> <Left>
nnoremap <C-o> <Nop>

vnoremap L <End>
vnoremap H <Home>
vnoremap K <C-u>
vnoremap J <C-d>
vnoremap <C-k> gk
vnoremap <C-j> gj
vnoremap <C-l> <Right>
vnoremap <C-h> <Left>
vnoremap <C-r> g_
vnoremap <C-e> <Home>

cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>
cnoremap <C-r> <End>
cnoremap <C-e> <Home>
cnoremap <C-u> <BS>
cnoremap <C-o> <Del>
cnoremap <C-f> <Esc>

" remove search highlighing when ESCing in normal mode
nnoremap <silent> <C-w><Space> :nohlsearch<CR>
"to remove search pattern use ':let @/ = ""<CR>'
nnoremap f <Esc>
nmap <C-f> f
nmap F f

cnoremap <C-f> <Esc>
cnoremap <f> <Esc>

" visual mode behaviour (don't copy on escape)
nnoremap dd "_dd
nmap DD dd
vnoremap <Esc> "_<Esc>
vnoremap o c
vnoremap f <Esc>
vmap F f
vmap <C-f> f

cmap ;\ \(\)<Left><Left>


" simple commenting by visual select and [,] and [.]
"vmap . :s:^://<CR>:nohlsearch<CR>
"vmap , :s:^\(\s*\)//:\1<CR>:nohlsearch<CR>

" fix arrow keys and delete
imap <Esc>[A <Up>
imap <Esc>[B <Down>
imap <Esc>[C <Right>
imap <Esc>[D <Left>
vmap <Esc>[A <Up>
vmap <Esc>[B <Down>
vmap <Esc>[C <Right>
vmap <Esc>[D <Left>"
imap <Esc>[3~ <Del>
imap <Esc>[Z <S-Tab>
vmap <Esc>[Z <S-Tab>
nmap  <Esc>[Z <S-Tab>

" navigate previous changes
nnoremap <C-n> g;
nnoremap <C-m> g,

" fix tabing (only shift-tab in insert mode not working)
vnoremap <C-t> >gv
vnoremap <C-d> <gv
nnoremap <C-t> i<C-t><Esc>
nnoremap <C-d> i<C-d><Esc>
vnoremap <Tab> >gv
vnoremap <s-Tab> <gv
nnoremap <Tab> i<C-t><Esc>
nnoremap <S-Tab> a<C-d><Esc>

inoremap <C-Space> <Space>
" when wrapping, still be able to move line by line

" fix counter issue:
nnoremap <C-a> <Esc>

" -----------------------------------------------------------------------------
" copy-pasting
" -----------------------------------------------------------------------------

vnoremap d "_d
vnoremap c c<Esc>
vnoremap P "_dp
vnoremap p "_dP
nnoremap p P
nnoremap P p

" copy/paste to/from system buffer
" 'vim --version' will need to return +clipboard and +xterm_clipboard

if has("clipboard") && has("xterm_clipboard")
    set clipboard=unnamedplus
    vnoremap <C-y> "+y
    vnoremap <C-c> "+c
    nnoremap <C-p> "+P
    vnoremap <C-p> "_d"+P
else
    vnoremap <C-y> <Esc>:echo "No clipboard support..."<CR>
    vnoremap <C-c> <Esc>:echo "No clipboard support..."<CR>
    nnoremap <C-p> <Esc>:echo "No clipboard support..."<CR>
    vnoremap <C-p> <Esc>:echo "No clipboard support..."<CR>
end

" work around with no clipboard support, copy to file:
"vmap <C-y> :w! ~/.copybuffer<CR>i<Esc>
"nmap <C-p> :execute ':read '.expand('$HOME/.copybuffer')<CR>

" -----------------------------------------------------------------------------
" changing colors
" -----------------------------------------------------------------------------

let g:color_toggle = 1
function! Color_toggle()
    if g:color_toggle
        set background=dark
        set t_ut=
        set t_Co=256
        colorscheme mycolorscheme
        let g:color_toggle = 0
    else
        set background=dark
        set t_ut=
        let g:solarized_termcolors=256
        colorscheme solarized
        let g:color_toggle = 1
    endif
endfunction
nnoremap <F8> :call Color_toggle()<cr>

execute Color_toggle()

" -----------------------------------------------------------------------------
" spell and grammar check
" -----------------------------------------------------------------------------



command Spell call SpellCheck()
nnoremap <C-w><C-s> :Spell<CR>
"set spellfile=~/.vim/spell/techspeak.utf-8.add
let b:enableSpellCheck=0
function! SpellCheck()
    if exists('b:enableSpellCheck') && b:enableSpellCheck == 1
        let b:enableSpellCheck=0
        setlocal nospell
    else
        let b:enableSpellCheck=1
        setlocal spellfile+=~/.vim/spell/en.utf-8.add
        setlocal spellfile+=oneoff.utf-8.add
        setlocal spell spelllang=en_us
        nnoremap gn ]s
        nnoremap gp [s
        nnoremap gf z=
        nnoremap gA 1zg
        nnoremap ga 2zg
        nnoremap gi zG
    endif
endfunction


command Grammar call GrammarCheck()
nnoremap <C-w><C-g> :Grammar<CR>
let b:enableSpellCheck=0
function! GrammarCheck()
    if exists('b:enableGrammarCheck') && b:enableGrammarCheck == 1
        let b:enableSpellCheck=0
        GrammarousReset
    else
        let b:enableSpellCheck=1
        GrammarousCheck
    endif
endfunction

let g:grammarous#hooks = {}
function! g:grammarous#hooks.on_check(errs) abort
    nmap <buffer>gn <Plug>(grammarous-move-to-next-error)
    nmap <buffer>gp <Plug>(grammarous-move-to-previous-error)
    nmap <buffer>gf <Plug>(grammarous-fixit)
    nmap <buffer>gi <Plug>(grammarous-remove-error)
    nmap <buffer>gI <Plug>(grammarous-disable-rule)
endfunction
function! g:grammarous#hooks.on_reset(errs) abort
    nunmap <buffer>gn
    nunmap <buffer>gp
    nunmap <buffer>gf
    nunmap <buffer>gi
    nunmap <buffer>gI
endfunction


