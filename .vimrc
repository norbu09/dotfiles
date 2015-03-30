" clear all mappings
mapclear
mapclear!


" remove all default autocommands
au!

" setup Vundel
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Vundle managed plugins
Plugin 'sjl/gundo.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-commentary'
Plugin 'bling/vim-airline'
Plugin 'edkolev/tmuxline.vim'
Bundle 'wakatime/vim-wakatime'
Bundle 'farseer90718/vim-taskwarrior'
Bundle 'Shougo/unite.vim'

" language support
Plugin 'scrooloose/syntastic'
Plugin 'mattfoster/vim-Perl-Critic'
Plugin 'jimenezrick/vimerl'
Plugin 'elixir-lang/vim-elixir'

" Snippets management
Bundle "MarcWeber/vim-addon-mw-utils.git"
Bundle "tomtom/tlib_vim.git"
Bundle "spf13/snipmate.vim"
Bundle 'carlosgaldino/elixir-snippets'

" mail support
Plugin 'lbdbq'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


" set preferred options
set   autoindent
set   background=light
set   backspace=2
set   backup
set   backupdir=./.vimbk,.
set   backupext=.vimbk
set   cmdheight=2
"set   columns=120
set   comments&
set   directory=.
set   noequalalways
set   expandtab
set   formatoptions=tcq 
set   hidden
set   history=300
set   hlsearch
set   incsearch
set   ignorecase
set   smartcase
set   nojoinspaces
set   nocindent 
set   keywordprg=man
set   listchars=eol:$,tab:>.,trail:$,extends:>
set   ruler
set   scrolloff=5
set   shiftwidth=4
set   shortmess=at
set   showcmd
set   showmatch
set   sidescroll=1
set   nostartofline
set   suffixes=.bak,~,.o,.obj,.swp,.pch
set   tabstop=4
set   textwidth=72
set   viminfo='50,ra:,rb:,\"100,%,n~/.viminfo
set   visualbell
set   wildmode=list:full,full
set   nowrap
set   writebackup
set   foldmethod=marker

set exrc

" c-] (jump to tag) not available in BSD
nnoremap ,m <c-]>
" dont use Q for Ex mode
map Q :q

" colours
colors zenburn

" syntastic settings
let g:syntastic_enable_perl_checker = 1
let g:syntastic_perl_checkers = ['perl']

let g:tmuxline_powerline_separators = 0
let g:tmuxline_preset = {
      \'a'    : '#S',
      \'c'    : '#(battery -t)',
      \'win'  : ['#I', '#W'],
      \'cwin' : ['#I', '#W', '#F'],
      \'y'    : ['%R', '%a', '%Y'],
      \'z'    : '#H'}



" syntax highlighting switch
function! SwitchSyntax()
    if has("syntax_items")
        syntax off
    else
        syntax on
    endif
endfunction
nmap <F7> :call SwitchSyntax() <CR>
imap <F7> <C-O>:call SwitchSyntax() <CR>
map <f6> :nohlsearch<cr>

" line numbers switch
function! SwitchNumbers()
    if &number
        set nonumber
    else
        set number
    endif
endfunction
nmap <F8> :call SwitchNumbers() <CR>
imap <F8> <C-O>:call SwitchNumbers() <CR>

" jump to next/prev error
"nmap <C-n>   :cn <CR>
"nmap <C-p> :cp <CR>
"imap <C-n>   <C-O>:cn <CR>
"imap <C-p> <C-O>:cp <CR>

" paste mode
function! SwitchPaste()
    if &paste
        set nopaste
    else
        set paste
    endif
endfunction
nmap \p :call SwitchPaste() <CR>
imap \p <C-O>:call SwitchPaste() <CR>

" to next window
" nnoremap <f2> <c-w>w
" switch tab
nmap <F3> gt<cr>
nmap <S-F3> gT<cr>

" insert date/time
inoremap <c-t> <c-r>=strftime("%Y-%m-%dT%H:%M:%S")<cr>

" no hlsearch at startup
autocmd VimEnter * nohlsearch

" Defaults for all files, may be overwritten in specific group
autocmd BufRead,BufNewFile * set formatoptions=tcq nocindent comments&


" save to a subdirectory; create it if it doesn't exist
function! DirCreate(name)
    if !isdirectory(a:name)
        execute "!mkdir " a:name
    endif
endfunction

autocmd BufWritePre * call DirCreate(expand("<afile>:p:h") . "/.vimbk")


" Settings for C sources
let c_space_errors=1
let c_syntax_for_h=1
augroup cprog
  " Remove all cprog autocommands
  au!

  " When starting to edit a file:
  "   For *.c and *.h files set formatting of comments and set C-indenting on.
  autocmd BufRead,BufNewFile *.c,*.h set formatoptions=croq
  autocmd BufRead,BufNewFile *.c,*.h set cindent
  autocmd BufRead,BufNewFile *.c,*.h set comments=sr:/*,mb:*,el:*/,://
  autocmd BufRead,BufNewFile *.c,*.h set textwidth=65
  autocmd BufEnter *.c,*.h,[Mm]akefile set errorformat=%f:%l:%m
augroup END

com! -range FixComment s+//\\(.*\\)$+/*\\1\\\ */+c
com! -nargs=* CC up <nl> !gcc -ansi -Wall -O2 -W <args> -o %:r % 2>&1 | tee %:r.err <nl> cf %:r.err
com! -nargs=* LINT up <nl> !lint -aa -b -c -e -h -p -r -s -x -F -H <args> % 2>&1 | tee %:r.err <nl> cf %:r.err
com! Fkt ?^{??^\k.*(? mark k | echo getline("'k")
com! SynID echo synIDattr(synID(line("."), col("."), 1), "name")


" Settings for perl
augroup perl
  au!

  " check perl code with :make
  au BufRead,BufNewFile *.pl,*.pm,*d,*d.* set filetype=perl | compiler perl

  " perl critic

  " autoindent
  autocmd FileType perl set autoindent|set smartindent
  let perl_fold=1

  nmap ,3 :!perlcritic -severity 2 -verbose 10 %<CR>
  nmap ,4 :!perlcritic -severity 2 -verbose 1 %<CR>
  
  " pod stuff
  let perl_include_pod = 1
  " comment/uncomment
  map ,1 :s/^/# /<CR>
  map ,2 :s/^# //<CR>

  " autocomplete code

  func Eatchar(pat)
    let c = nr2char(getchar(0))
    return (c =~ a:pat) ? '' : c
  endfunc

  " iabbr <silent> if if ( ) {<CR>}<up><C-R>=Eatchar('\s')<CR><right><right><right><right>
  " iabbr <silent> sub sub  {<CR><CR>}<up><up><right><right><right><C-R>=Eatchar('\s')<CR>

augroup END

" Settings for makefiles
augroup make
  au!

  autocmd BufRead,BufNewFile *[Mm]akefile*,*.mak set formatoptions=croq
  autocmd BufRead,BufNewFile *[Mm]akefile*,*.mak set comments+=b:#
  autocmd BufRead,BufNewFile *[Mm]akefile*,*.mak set textwidth=65
augroup END

" Settings for vim scripts
augroup vim
  au!

  autocmd BufRead,BufNewFile *vimrc*,*.vim,.exrc,_exrc set formatoptions=croq
  autocmd BufRead,BufNewFile *vimrc*,*.vim,.exrc,_exrc set comments+=b:\"
  autocmd BufRead,BufNewFile *vimrc*,*.vim,.exrc,_exrc set textwidth=65
augroup END


" HTML sources
augroup html
  " Remove all html autocommands
  au!

  " Set options for HTML files
  " limit textwidth and adjust for german umlauts
  autocmd BufEnter *.html,*.sgml,*.tpl inoremap ä &auml;
  autocmd BufEnter *.html,*.sgml,*.tpl inoremap Ä &Auml;
  autocmd BufEnter *.html,*.sgml,*.tpl inoremap ö &ouml;
  autocmd BufEnter *.html,*.sgml,*.tpl inoremap Ö &Ouml;
  autocmd BufEnter *.html,*.sgml,*.tpl inoremap ü &uuml;
  autocmd BufEnter *.html,*.sgml,*.tpl inoremap Ü &Uuml;
  autocmd BufEnter *.html,*.sgml,*.tpl inoremap ß &szlig;
  autocmd BufLeave *.html,*.sgml,*.tpl iunmap ä
  autocmd BufLeave *.html,*.sgml,*.tpl iunmap Ä
  autocmd BufLeave *.html,*.sgml,*.tpl iunmap ü
  autocmd BufLeave *.html,*.sgml,*.tpl iunmap Ü
  autocmd BufLeave *.html,*.sgml,*.tpl iunmap ö
  autocmd BufLeave *.html,*.sgml,*.tpl iunmap Ö
  autocmd BufLeave *.html,*.sgml,*.tpl iunmap ß

  autocmd BufEnter *.sgml inoreabbrev li <listitem><para></para></listitem><C-O>17h
  autocmd BufEnter *.sgml inoreabbrev pa <para></para><C-O>6h
  autocmd BufEnter *.sgml inoreabbrev em <emphasis></emphasis><C-O>11h
  autocmd BufEnter,BufNew *.sgml set errorformat=nsgmls:%f:%l:%c:%t:%m
augroup END


" gzipped archives
augroup gzip
  " Remove all gzip autocommands
  au!

  " Enable editing of gzipped files
  "	  read:	set binary mode before reading the file
  "		uncompress text in buffer after reading
  "	 write:	compress file after writing
  "	append:	uncompress file, append, compress file
  autocmd BufReadPre,FileReadPre	*.gz set bin
  autocmd BufReadPost,FileReadPost	*.gz let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost	*.gz '[,']!gunzip
  autocmd BufReadPost,FileReadPost	*.gz set nobin
  autocmd BufReadPost,FileReadPost	*.gz let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost	*.gz execute ":doautocmd BufReadPost " . expand("%:r")

  autocmd BufWritePost,FileWritePost	*.gz !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost	*.gz !gzip <afile>:r

  autocmd FileAppendPre			*.gz !gunzip <afile>
  autocmd FileAppendPre			*.gz !mv <afile>:r <afile>
  autocmd FileAppendPost		*.gz !mv <afile> <afile>:r
  autocmd FileAppendPost		*.gz !gzip <afile>:r
augroup END

" Tidy selected lines (or entire file) with _t:
nnoremap <silent> _t :%!perltidy -q -st -se -i=4 -ci=4 -pt=2 -otr -sot -sct -nsfs -noll -nola<Enter>
vnoremap <silent> _t :!perltidy -q -st -se -i=4 -ci=4 -pt=2 -otr -sot -sct -nsfs -noll -nola<Enter>

" call pathogen#infect()

if has("autocmd")
  filetype plugin indent on
endif

autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" erlang presets
"let erlang_skel_header = {"author": {"lenz@springtimesoft.com"}, "owner" : {"Springtimesoft LTD"}}
let erlang_man_path = "/usr/local/share/man"

let g:snippets_dir = "~/.vim/snippets"
let g:snips_author = 'Lenz Gschendtner (springtimesoft LTD)'

" airline settings
"
let g:airline#extensions#tabline#enabled = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
" unicode symbols
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols.linenr = '⌙'
let g:airline_symbols.branch = '⌥'
let g:airline_symbols.paste = '✁'
let g:airline_symbols.whitespace = '‣'

" Gundo settings
nnoremap <F5> :GundoToggle<CR>

