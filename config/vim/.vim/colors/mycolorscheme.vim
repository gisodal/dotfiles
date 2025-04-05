" Vim color file

set background=dark
set t_Co=256
let g:colors_name="mycolorscheme"

let python_highlight_all = 1
let c_gnu = 1


hi Normal	    ctermfg=253         ctermbg=None        cterm=None
hi Cursor       ctermfg=248         ctermbg=57          cterm=None
hi SpecialKey	ctermfg=70          ctermbg=None        cterm=None
hi Directory	ctermfg=4           ctermbg=None        cterm=Bold
hi ErrorMsg     ctermfg=160         ctermbg=245         cterm=None
hi PreProc	    ctermfg=243         ctermbg=None        cterm=Bold
hi Search	    ctermfg=125         ctermbg=None        cterm=Bold
hi Type		    ctermfg=202         ctermbg=None        cterm=Bold
hi Statement	ctermfg=172         ctermbg=None        cterm=Bold
hi Comment	    ctermfg=240         ctermbg=None        cterm=None
hi LineNr	    ctermfg=244         ctermbg=233         cterm=None
hi NonText	    ctermfg=None        ctermbg=None        cterm=None
hi Constant	    ctermfg=76          ctermbg=None        cterm=None
hi Todo         ctermfg=162         ctermbg=None        cterm=Bold
hi Identifier	ctermfg=253         ctermbg=None        cterm=Bold
hi Error	    ctermfg=None        ctermbg=196         cterm=Bold
hi Special	    ctermfg=172         ctermbg=None        cterm=Bold
hi Ignore       ctermfg=221         ctermbg=None        cterm=Bold
hi Underline    ctermfg=147         ctermbg=None        cterm=Italic
hi ColorColumn                      ctermbg=235
hi SignColumn   ctermfg=253         ctermbg=None        cterm=None
hi MatchParen   ctermfg=202         ctermbg=226         cterm=bold

hi DiffAdd      ctermfg=None        ctermbg=28     cterm=none
hi DiffChange   ctermfg=None        ctermbg=127     cterm=none
hi DiffDelete   ctermfg=None        ctermbg=160     cterm=bold
hi DiffText     ctermfg=None        ctermbg=132    cterm=none

hi FoldColumn	ctermfg=132         ctermbg=None        cterm=None
hi Folded       ctermfg=132         ctermbg=None        cterm=Bold

hi Visual       ctermfg=248         ctermbg=238         cterm=None

hi Pmenu        ctermfg=62          ctermbg=233         cterm=None
hi PmenuSel     ctermfg=69          ctermbg=232         cterm=Bold
hi PmenuSbar    ctermfg=247         ctermbg=233         cterm=Bold
hi PmenuThumb   ctermfg=248         ctermbg=233         cterm=None

hi VertSplit    ctermfg=232         ctermbg=none        cterm=None

hi TabLine      ctermfg=245         ctermbg=239         cterm=None
hi TabLineFill  ctermfg=239         ctermbg=239
hi TabLineSel   ctermfg=104         ctermbg=236         cterm=Bold

" highlight cursor position
hi CursorColumn ctermfg=None        ctermbg=235         cterm=None
hi CursorLine   ctermfg=None        ctermbg=235         cterm=None

function! LocateCursor()
    set nocursorline nocursorcolumn
    for i in [1, 2, 3, 4, 5, 6]
        set cursorline! cursorcolumn!
        redraw
        sleep 60m
    endfor
endfunction
nnoremap <silent> t :call LocateCursor()<CR>

" statusline coloring
" first, enable status line always
set laststatus=2
hi StatusLineNC ctermfg=248         ctermbg=233         cterm=None
hi StatusLine   ctermfg=4           ctermbg=233         cterm=bold

if version >= 700
    au InsertEnter * silent call StatusInsert()
    au InsertLeave,BufEnter,BufWritePost * silent call StatusNormal()
endif



function! StatusInsert()
    hi StatusLine ctermfg=0 ctermbg=172 cterm=None
endfunction

function! StatusNormal()
     if (&mod == 0)
         hi StatusLine ctermfg=4 ctermbg=233 cterm=Bold
     else
         hi StatusLine ctermfg=1 ctermbg=233 cterm=Bold
     endif
endfunction

" undo / redo with 'r' and 'u', with coloring
nnoremap <silent> R :redo<CR>:silent call StatusNormal()<CR>
nnoremap <silent> U :undo<CR>:silent call StatusNormal()<CR>
nmap r R
nmap u U

