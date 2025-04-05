" clear any existing autocommands:
autocmd!

" -----------------------------------------------------------------------------
" Basic settings
" -----------------------------------------------------------------------------
let g:tex_flavor = "latex"          " prefer 'latex' when tex files are opened
set shortmess+=I                    " no startup message on empty file
set nocompatible                    " don't make compatible with vi
set term=xterm-256color             " 256 color vim :)

set cindent                         " programmers autoindent, and dont remove indent on '#':
set shiftwidth=4
set softtabstop=4                   " tab is 4 spaces in insert mode
set tabstop=4                       " tab is 4 spaces

set sidescrolloff=10                " horizontal area around cursor
set scrolloff=10                    " vertical area around cursor

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
set nowrap
set shell=/bin/bash
set autoread                        " auto read when file changes from external source
"set colorcolumn=80                  " indicator for line width
set encoding=utf8                   " set utf8 as standard encoding
let mapleader=","                   " we can now use <leader> for additional key combinations
set nostartofline                   " dont jump to first non-blank chararcter on line
set magic                           " use regular expressions

set nofoldenable                      " disable folding
set foldlevelstart=99                 " disable folding
set diffopt+=context:99999            " disable folding
let g:vim_markdown_folding_disabled=1 " disable folding

syntax on                           " syntax highlighting

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
endif | endif

" -----------------------------------------------------------------------------
" Plugin configurations
" -----------------------------------------------------------------------------

filetype off      " required

if !filereadable(expand("~/.vim/bundle/Vundle.vim/autoload/vundle.vim"))
    try
        silent! execute "silent !git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim"
        let g:install_plugins=1
    catch
    endtry
endif

" -----------------------------------------------------------------------------
" Show filename of currently focussed file in the tmux statusbar
" -----------------------------------------------------------------------------

" alternative 1: print filename to terminal title and use #T in tmux
set title                           " set terminal title to current open file
autocmd BufEnter * let &titlestring = ' ' . expand("%:t")  " set terminal title


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

" resize windows on terminal resize
autocmd VimResized * :wincmd =

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

" make pretty columns in visual mode
vnoremap t !column -t<CR>

" remove newline and add space
vnoremap n :-1s/\n/\ /g<CR>

" reload configuration
nnoremap <C-w>r :source ~/.vimrc<CR>

" search will center on target found
nnoremap N Nzz
nnoremap n nzz

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

inoremap <C-k> <Up>
inoremap <C-j> <Down>
inoremap <C-l> <Right>
inoremap <C-h> <Left>

nnoremap i <Esc>i
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

" remove search highlighing when ESCing in normal mode
nnoremap <silent> <C-w><Space> :nohlsearch<CR>
"to remove search pattern use ':let @/ = ""<CR>'

" visual mode behaviour (don't copy on escape)
nnoremap dd "_dd
nmap DD dd
vnoremap <Esc> "_<Esc>

" simple commenting by visual select and [,] and [.]
"vmap . :s:^://<CR>:nohlsearch<CR>
"vmap , :s:^\(\s*\)//:\1<CR>:nohlsearch<CR>

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
    nmap <buffer>gw <Plug>(grammarous-open-info-window)
    nmap <buffer>gf <Plug>(grammarous-fixit)
    nmap <buffer>gi <Plug>(grammarous-remove-error)
    nmap <buffer>gI <Plug>(grammarous-disable-rule)
endfunction
function! g:grammarous#hooks.on_reset(errs) abort
    nunmap <buffer>gn
    nunmap <buffer>gw
    nunmap <buffer>gp
    nunmap <buffer>gf
    nunmap <buffer>gi
    nunmap <buffer>gI
endfunction


