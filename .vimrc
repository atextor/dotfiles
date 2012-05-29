version 6.0

""""" general settings, may be overwritten by situation-specific settings below
set noautoindent             " copy indent from current line when starting a new line?
set   autowrite              " automatically save modifications when using critical (external) commands
set   background=dark        " working on a `light' or `dark' background?
set   backspace=2            " a value of `2' makes backspace work always
set nobackup                 " do backups?
set   cmdheight=3            " avoid many cases of "press enter to continue"
set nocompatible             " be compatible to vi?
set   confirm                " ask to save unsaved when quitting
set nodigraph                " enable entering of digraphs in insert mode?
set noerrorbells             " ring bell on error messages?
set noesckeys                " allow usage of cursor keys within insert mode?
set noexpandtab              " expand tabs to spaces?
set nofoldenable             " don't use the annoying folding
set   hidden                 " use hidden buffers
set nohlsearch               " don't highlight search results
set noicon                   " set icon text of window (if supported by x terminal)
set   ignorecase             " ignore case when searching?
set   incsearch              " incremental search?
set   isfname+=/,.           " characters here are included in file and path names
set   laststatus=2           " a value of `2' means show the statusline always
set   lazyredraw             " don't update screen while executing macros?
set   list                   " list and listchars: display tab character as dot
set   listchars=tab:.\ ,trail:\ 
set   magic                  " extended regular expressions?
set   modeline               " allow modeline?
set   modelines=1            " a value of `1' means last line of file can be modeline
set nonumber                 " display line numbers?
set   pastetoggle=<F11>      " set a key to toggle paste mode
set   report=0               " report when n lines were changed (`0' = show all changes)
set   ruler
set   scrolloff=10           " vim will already start scrolling when n lines from bottom
set   shiftwidth=4           " use n spaces for each step of (auto)indent
set   shortmess=I            " a value of `I' means no intro message
set noshowcmd                " show incomplete command?
set   showmatch              " show matching bracket?
set   showmode               " if in insert, replace or visual mode, show it in last line?
set nosmartindent            " smart autoindenting?  (for C source code, use `cindent')
set   softtabstop=4          " number of spaces for tabs
set   splitbelow             " open new windows below current one?
set nostartofline            " when off, tries to keep cursor in current column
set   statusline=[%n]\ %f\ %(\ %M%R%H)%)\ <%l\,%c%V>\ %P\ ASCII=%b\ HEX=%B
set   tabstop=4              " tab width
set notitle                  " set window title (if supported by x terminal)?
set   ttyfast                " fast terminal connection?
set   undolevels=200
set   visualbell             " use visualbell, then set it to nothing (want neither beep nor blink)
set   t_vb=
set   wildchar=<TAB>
set   wildignore=*.o
set   wrapmargin=1           " wrap if n spaces from right border
"set tags=/path/to/tags
colorscheme elflord

" shell: set it according to the OS being used
if has("linux")
	let &shell="bash"
endif

" specific settings if we have color support
if has("syntax") && (&t_Co > 1 || has("gui_running"))
	syntax on
endif

" specific settings for GUI mode
if has("gui_running")
	set mouse=a
	set guifont=Bitstream\ Vera\ Sans\ Mono\ 11
	set background=dark
	colorscheme elflord
" specific settings for text mode
else
	" xterm mousewheel
	"map  <xCSI>[62~ <MouseDown>
	"map! <xCSI>[62~ <MouseDown>
	"map  <xCSI>[63~ <MouseUp>
	"map! <xCSI>[63~ <MouseUp>
	"map  <xCSI>[64~ <S-MouseDown>
	"map! <xCSI>[64~ <S-MouseDown>
	"map  <xCSI>[65~ <S-MouseUp>
	"map! <xCSI>[65~ <S-MouseUp>
endif

"-------------------------------------------------
" Mappings
"-------------------------------------------------
map     <PageUp>   <C-B>
map     <PageDown> <C-F>
map     <C-j> <ESC>30j<CR>
map     <C-k> <ESC>30k<CR>
map     :alias     map
map     :which     map
map     \\         <C-]>         " `\\' in online help also jumps to help positions

" delete trailing whitespace
nmap    <F9> :%s/\s\+$//<CR>
vmap    <F9> :s/\s\+$//<CR>
" delete trailing \r
cmap    ,rcm  :%s/\r//g<CR>
" clear empty lines (containing only \s)
map     ,cel  :%s/^\s\+$//<CR>
vmap    ,cel  :s/^\s\+$//<CR>

noremap <C-g> 2<C-g>             " show current buffer number, too
map     Q     gq<CR>             " use Q for formatting, not Ex mode
map     <C-z> :noh<CR>           " highlights off (2nd function: suspend off)

"navigating buffers and tabs
map     <C-h> :bp<CR>
map     <C-l> :bn<CR>
"map     <C-w> :bdelete<CR>

" emacs-style shortcuts when in command mode (like in many shells)
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" if you paste and indentation gets screwed, just hit Ctrl+A
inoremap <silent> <C-a> <ESC>u:set paste<CR>.:set nopaste<CR>gi

" to reformat a paragraph to fit some textwidth, use this
" to adjust it to the current position of the cursor
map      #tw :set textwidth=<C-r>=col(".")<C-m>

"icomplete
imap     <C-n> <C-x><C-o>

"-----------------------------------------------------------------------
" Autocommands
"-----------------------------------------------------------------------
" NOTE: ai = autoindent, et = expandtab, sw = shiftwidth, ts = tabstop,
" tw = textwidth, fo = formatoptions

" Ensure that autocmds aren't loaded n times if .vimrc is sourced n times
if !exists("autocmds_loaded")
	let autocmds_loaded = 1

	" Flexible Indenting for many languages
	"filetype indent on

	" C and C++
	augroup cprog
		au!
		au FileType c,cpp,cc set ai cin fo=croql sw=4 softtabstop=4 tw=78 wm=3 number smartindent
		au FileType c,cpp,cc hi PreProc
		au FileType c,cpp,cc nmap ,ci  :w<cr>:!indent %<cr>:e!<cr>
		au FileType c,cpp,cc nmap ,cci :w<cr>:!astyle --style=ansi %<cr>:e!<cr>
	augroup END

	" HTML and PHP
	augroup html
		au!
		au FileType html,htm,shtml,shtm,php3,php4,php5,phtml,php set nocin ai sw=4 ts=4 smartindent
	augroup END

	" Mails
	augroup mail
		au!
		au FileType mail set tw=72 fo=aw2tq
	augroup END

	" LaTeX
	" In order to use the LaTeX mappings, you need to have the following script as `xdvi-remote.sh'
	" in your path which in turn requires xsendkey (http://people.csail.mit.edu/adonovan/hacks/xsendkey.html):
	"
	" #!/bin/bash
	" if [ "x$DISPLAY" = "x" ]; then exit; fi
	" x="x"
	" case "$1" in
	" 'refresh') x="Control+R";;
	" 'pgdown') x="n";;
	" 'pgup') x="p";;
	" *) echo "Usage: $0 [refresh|pgdown|pgup]"
	" esac
	" [ "$x" != "x" ] && xsendkey -window $(xwininfo -root -tree|grep xdvik|sed 's/^ *//g'|cut -d' ' -f1) "$x"
	augroup latex
		au!
		au FileType tex set tw=100 fo=aw2tq
		" Use Alt-j and Alt-k in vim to go a page up or down in an open xdvi instance
		au FileType tex map <ESC>j :silent !xdvi-remote.sh pgdown 2>&1 >/dev/null<CR>
		au FileType tex map <ESC>k :silent !xdvi-remote.sh pgup 2>&1 >/dev/null<CR>
		au FileType tex map ,x :execute '!xdvi -editor "vim --servername vimtex --remote +\%l \%f" -sourceposition ' . line(".") . expand("%") . " " . expand("%:r") . ".dvi &"<CR><CR>
		"au FileType tex map ,l :w!<CR>:!clear; latex %; xdvi %<.dvi &<CR><CR>
		au FileType tex map ,l :w!<CR>:!make 2>&1 >/dev/null && xdvi-remote.sh refresh<CR><CR>
	augroup END

	" XML
	augroup xml
		au!
		"au FileType xml exe ":silent 1,$!xmllint --format --recover - 2>/dev/null" 
	augroup END
endif

"-------------------------------------------------
" Plugin Configurations
"-------------------------------------------------
" ctags.vim
map ,c :CTAGS

"let g:ctags_path = '/usr/share/vim/plugins/ctags'
let g:ctags_args = '-I __declspec+'
let g:ctags_title = 1
let g:ctags_statusline = 1
let generate_tags = 1

" showmarks.vim
hi ShowMarksHLl cterm=bold ctermfg=7 ctermbg=4
let g:showmarks_textlower="\t-"
hi ShowMarksHLu cterm=bold ctermfg=0 ctermbg=2
let g:showmarks_textupper="\t-"
hi ShowMarksHLo cterm=bold ctermfg=0 ctermbg=3
let g:showmarks_textother="\t-"
hi ShowMarksHLm cterm=bold ctermfg=0 ctermbg=1
let g:showmarks_ignore_type="hmpqr"

