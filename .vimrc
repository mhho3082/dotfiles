set nocompatible
" set compatible " Fixes 'Set first letter as g' problem for some versions of vim, see https://stackoverflow.com/a/39874424

syntax on
let mapleader = " "
set mouse=a

nnoremap j gj
nnoremap k gk

set t_Co=256
set background=dark

" Set cursor for SSH
" https://vim.fandom.com/wiki/Change_cursor_shape_in_different_modes
let &t_SI.="\e[6 q"
let &t_SR.="\e[4 q"
let &t_EI.="\e[2 q"

" https://stackoverflow.com/a/42118416
autocmd VimEnter * silent !echo -ne "\e[2 q"

" https://stackoverflow.com/a/58042714
set ttimeout
set ttimeoutlen=1
set ttyfast
