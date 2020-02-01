set  rtp+=/home/momir/.local/lib/python3.6/site-packages/powerline/bindings/vim/
set laststatus=2
set t_Co=256
let g:powerline_pycmd = 'py3'
" tab navigation: Alt or Ctrl+Shift may not work in terminal:
" http://vim.wikia.com/wiki/Alternative_tab_navigation
" Tab navigation like Firefox: only 'open new tab' works in terminal
nnoremap <C-t>     :tabnew<CR>
inoremap <C-t>     <Esc>:tabnew<CR>
" move to the previous/next tabpage.
nnoremap <C-j> gT
nnoremap <C-k> gt
" Go to last active tab 
au TabLeave * let g:lasttab = tabpagenr()
nnoremap <silent> <c-l> :exe "tabn ".g:lasttab<cr>
vnoremap <silent> <c-l> :exe "tabn ".g:lasttab<cr>


syntax enable
set background=light
" let g:solarized_termcolors=256
let g:solarized_termtrans=1
colorscheme solarized


call plug#begin('~/.vim/plugged')
  
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'w0rp/ale'
Plug 'powerline/powerline'
Plug 'altercation/solarized'

call plug#end()
