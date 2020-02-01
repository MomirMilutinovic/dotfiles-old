set laststatus=2
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

call plug#begin('~/.vim/plugged')
  
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'w0rp/ale'

call plug#end()
