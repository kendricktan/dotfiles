" Use Vim settings, rather than Vi Settings
set nocompatible

"************************************************
"" Vim-Plug
"************************************************

let nvimplug_exists=expand('~/.config/nvim/autoload/plug.vim')

if !filereadable(nvimplug_exists)
  echo "Installing Vim-Plug..."
  echo ""
  silent !
  silent !\curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

"************************************************
"" Plugins
"************************************************
" Required to call `Plug`
call plug#begin(expand('~/.config/nvim/plugged'))

" Core tools
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " Autocomplete
Plug 'vim-airline/vim-airline'		" Status bar on the bottom
Plug 'sbdchd/neoformat'			" Format code with one button press
Plug 'sheerun/vim-polyglot'		" Collection of language packs for VIM
Plug 'scrooloose/nerdtree' 		" Nerdtree
Plug 'terryma/vim-multiple-cursors' 	" Multiple cursors
Plug 'godlygeek/tabular'                " Align

" Haskell
Plug 'eagletmt/neco-ghc'		" ghc-mod
Plug 'neovimhaskell/haskell-vim' 	" Syntax highlighting and indentation

" Color schemes
Plug 'ajmwagar/vim-deus'

" End Plug session
call plug#end()

" Use Vim settings, rather than Vi Settings
set nocompatible
"************************************************
"" Settings
"************************************************
" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#disable_auto_complete = 1 

" airline
let g:airline#extensions#tabline#enabled = 1

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1

" haskell
"
let g:haskell_tabular = 1

let g:haskellmode_completion_ghc = 0
let g:haskell_classic_highlighting = 1
let g:syntastic_haskell_hdevtools_args = "-package-key ghc"

autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc shiftwidth=2 softtabstop=2

let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {
      \ 'haskell': ['hie-8.2', '--lsp'],
      \ }

nnoremap <F1> :call LanguageClient_contextMenu()<CR>

"************************************************
"" Key mappings
"************************************************
" Leader Key is `,`
let mapleader=','

" Buffer navigation
noremap <leader>q :bp<CR>
noremap <leader>w :bn<CR>
noremap <leader>c :bd<CR>
noremap <leader>C :bd!<CR>

" Clears highlighted search terms
nnoremap <silent> <C-l> :nohl<CR><C-l

" Opens terminal
noremap <leader>t :term<CR>

" Toggle terminal input
tnoremap <F12> <C-\><C-n> 

" AutoFormat
noremap <F5> :Neoformat<CR>

" Toggle paste
set pastetoggle=<F10>

" Copy/Paste from system clipboard
noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p

" Open Nerdtree
noremap <F3> :NERDTreeToggle<CR>

" Tab to autocomplete
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#mappings#manual_complete()
function! s:check_back_space() abort "{{{
let col = col('.') - 1
return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}

" Alignment
vmap a= :Tab /=<CR>
vmap a; :Tab /::<CR>
vmap a- :Tab /-><CR>
vmap a$ :Tab /$><CR>

"************************************************
"" Core
"************************************************
syntax on					" Syntax highlighting
filetype plugin indent on			" File type detection + language dependent indenting
let no_buffers_menu=1
set expandtab                                     " Expand TABS to spaces
set backspace=indent,eol,start			" Backspace works as expected
set relativenumber				" Relative line numbers
set hidden					" Allows hidden buffers
set cursorline					" Highlight current line
set shiftwidth=2
set softtabstop=2

" Jump back to last position
if has("autocmd")
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Fix terminal color scheme
set t_Co=256

" set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set background=dark " Setting dark mode

" Color scheme
colorscheme deus
let g:deus_termcolors=256