" NVIM config
" Author: Lenz Gschwendtner <lenz@springtimesoft.com>
" Repo: https://github.com/norbu09/dotfiles

" Setup Plugin manager ----------------------------{{{
" bootstrap dein package manager
if (!isdirectory(expand("$HOME/.config/nvim/repos/github.com/Shougo/dein.vim")))
		call system(expand("mkdir -p $HOME/.config/nvim/repos/github.com"))
		call system(expand("git clone https://github.com/Shougo/dein.vim $HOME/.config/nvim/repos/github.com/Shougo/dein.vim"))
endif

set runtimepath+=~/.config/nvim/repos/github.com/Shougo/dein.vim/
call dein#begin(expand('~/.config/nvim'))

call dein#add('Shougo/dein.vim')
call dein#add('sheerun/vim-polyglot')
call dein#add('benekastah/neomake')
call dein#add('Shougo/deoplete.nvim')
call dein#add('slashmili/alchemist.vim')
call dein#add('tpope/vim-obsession')
call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')
call dein#add('edkolev/tmuxline.vim')
call dein#add('jnurmine/Zenburn')
call dein#add('tomtom/tcomment_vim')
call dein#add('tpope/vim-fugitive')
call dein#add('tpope/vim-repeat')
call dein#add('tpope/vim-surround')
call dein#add('Shougo/unite.vim')
call dein#add('Chiel92/vim-autoformat')


if dein#check_install()
		call dein#install()
		let pluginsExist=1
endif

call dein#end()
filetype plugin indent on
" }}}

" Defaults {{{
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
" leader is ,
let mapleader = ','
" Let airline tell me my status
set noshowmode
set tabstop=4
set foldmethod=marker


" }}}

" Things run on save {{{
" format the autoformatter
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0

let g:formatdef_my_custom_perl = '"perltidy -q -st -se -i=4 -ci=4 -pt=2 -otr -sot -sct -nsfs -noll -nola"'
let g:formatters_perl = ['my_custom_perl']

" run the autoformatter first, then neomake
au BufWrite * :Autoformat
autocmd! BufWritePost * Neomake
" }}}

" Use deoplete.
let g:deoplete#enable_at_startup = 1

" Functions {{{
" paste mode
function! SwitchPaste()
		if &paste
				set nopaste
		else
				set paste
		endif
endfunction
" }}}

" Mappings {{{
nmap \p :call SwitchPaste() <CR>
imap \p <C-O>:call SwitchPaste() <CR>
nmap \\ :TComment <CR>
" }}}

" Theme {{{
syntax on
colorscheme zenburn
set background=dark
" set background=light
" no need to fold things in markdown all the time
let g:vim_markdown_folding_disabled = 1
" turn on spelling for markdown files
autocmd FileType markdown,text,html setlocal spell complete+=kspell
" highlight bad words in red
autocmd FileType markdown,text,html hi SpellBad guibg=#ff2929 guifg=#ffffff" ctermbg=224
" disable markdown auto-preview. Gets annoying
let g:instant_markdown_autostart = 0
" Keep my termo window open when I navigate away
autocmd TermOpen * set bufhidden=hide
"}}}

" Airline/Tmuxline settings {{{
"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tmuxline#enabled = 1
let g:airline#extensions#tabline#show_tab_nr = 0

let g:airline_section_z = airline#section#create(['%{ObsessionStatus(''♺'', '''')}', 'windowswap', '%3p%% ', 'linenr', ':%3v '])
let g:airline_theme='understated'

if !exists('g:airline_symbols')
		let g:airline_symbols = {}
endif
" unicode symbols
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols.linenr = '⌙'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.maxlinenr = '☰'
let g:airline_symbols.branch = ''
let g:airline_symbols.paste = '✁'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'"

let g:tmuxline_powerline_separators = 0
let g:tmuxline_preset = {
						\'a'    : '#S',
						\'c'    : '#(battery -t)',
						\'win'  : ['#I', '#W'],
						\'cwin' : ['#I', '#W', '#F'],
						\'y'    : ['%R', '%a', '%Y'],
						\'z'    : '#H'}
" }}}
