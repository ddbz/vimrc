" Tags: #do  |  
" Some tips taken from: http://nvie.com/posts/how-i-boosted-my-vim/

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
set laststatus=2  " Always display the status line

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" Don't use Ex mode, use Q for formatting #do - What is 'Ex' Mode?
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break. #do - What is
" this?
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
" if has('mouse')
"  set mouse=a
" endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" *Gary Additions*

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Enable spellchecking for Markdown
" autocmd FileType markdown setlocal spell

" Line Numbers
set number
set numberwidth=5

" Open new split panes to right and bottom, which feels more natural
" set splitbelow
" set splitright

" Color scheme
set background=dark
 highlight NonText guibg=#060606
 highlight Folded  guibg=#0A0A0A guifg=#9090D0

set cursorline
:hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white

"Speed up scrolling just a bit
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>

" Fix markdown syntax
au BufRead,BufNewFile *.md set filetype=markdown

" Adding Pathogen for plugin installations
" execute pathogen#infect()
" call pathogen#helptags()
" call pathogen#runtime_append_all_bundles()	" NVIE tip - Doesn't seem to
												" work. Potentially outdated.
" Hoping to get plugins to work in sessions
set sessionoptions-=options

" Sourcing .vimrc to save time
autocmd BufWritePost ~/.vimrc source %

augroup reload_vimrc " {
	    autocmd!
	        autocmd BufWritePost $MYVIMRC source $MYVIMRC
	augroup END " }

" Autocomplete
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

"autocmd FileType html set omnifunc=htmlcomplete#CompleteTags Save your backups to a less annoying place than the current directory.
" If you have .vim-backup in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/backup or . if all else fails.
if isdirectory($HOME . '/.vim/backup') == 0
	:silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
endif
set backupdir-=.
set backupdir+=.
set backupdir-=~/
set backupdir^=~/.vim/backup/
set backupdir^=./.vim-backup/
set backup

" Save your swp files to a less annoying place than the current directory.
" If you have .vim-swap in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/swap, ~/tmp or .
if isdirectory($HOME . '/.vim/swap') == 0
	:silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=./.vim-swap//
set directory+=~/.vim/swap//
set directory+=~/tmp//
set directory+=.

" viminfo stores the the state of your previous editing session
set viminfo+=n~/.vim/viminfo

if exists("+undofile")
	" undofile - This allows you to use undos after exiting and restarting
	" This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
	" :help undo-persistence
	" This is only present in 7.3+
	if isdirectory($HOME . '/.vim/undo') == 0
		:silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
	endif
	set undodir=./.vim-undo//
	set undodir+=~/.vim/undo//
	set undofile
endif

" Syntax Attribute Mapping (for identifying syntax)
autocmd FuncUndefined * exe 'runtime autoload/' . expand('<afile>') . '.vim'
map -a	:call SyntaxAttr()<CR>

" Turn off the spell check thing damnit.
set nospell

set linebreak
function! OpenUrlUnderCursor()
	let path="/Applications/Google\\ Chrome.app"
	execute "normal BvEy"
	let url=matchstr(@0, '[a-z]*:\/\/[^ >,;]*')
	if url != ""
		silent exec "!open -a ".path." '".url."'" | redraw! 
		echo "opened ".url
	else
		echo "No URL under cursor."
	endif
endfunction
nmap <leader>o :call OpenUrlUnderCursor()<CR>

" Toggle Cursorline
:nnoremap <Leader>c :set cursorline!<CR>
:nnoremap <Leader>C :set cursorcolumn!<CR>

" Fixing formatting for Markdown & Javascript
autocmd FileType markdown setlocal shiftwidth=4 tabstop=4 ai 
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 

" Set local syntax off
:nnoremap <Leader>S :setlocal syntax=0<CR>

" Changing the Terminal Tab Label
set title

" Quickly edit the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Hide buffers instead of closing them
set hidden

set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set shiftround
set autoindent
set copyindent
set ignorecase  " ignore case when searching
set smartcase  	" ignore case if search pattern is all lowercase
				" case-sensitive otherwise
"set smarttab	" insert tabs on the start of a line according to shiftwidth
				" not tabstop 
set visualbell
set noerrorbells
set scrolloff=4

" Toggle line numbers
nnoremap <leader>n :setlocal number!<cr>

" Toggle foldmethod indent
nnoremap <leader>i :setlocal foldmethod=indent<cr>
nnoremap <leader>I :setlocal nofoldenable<cr>

" Clear searches a bit easier
nmap <silent> ,/ :nohlsearch<CR>

" Forgot to sudo, shit... use two bangs to write
cmap w!!  %!sudo tee > /dev/null %

" Open/Closing folds > Space
nnoremap <space> za

" Colemak Config
noremap n j
noremap e k
noremap s f
noremap S F
noremap f e
noremap F E
noremap k n
noremap K N
noremap zn zj
noremap ze zk

" Easier window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Display Last line instead of @'s
 set display=lastline

" Macros
 let @c='^r-'
 let @z='^r•'
 let @x='^rX'
