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

" general behaviour
call dein#add('ryanoasis/vim-devicons')
call dein#add('Shougo/dein.vim')
call dein#add('Shougo/deoplete.nvim')
call dein#add('tpope/vim-fugitive')
call dein#add('tpope/vim-repeat')
call dein#add('tpope/vim-surround')
call dein#add('tpope/vim-obsession')
call dein#add('Shougo/unite.vim')
call dein#add('Chiel92/vim-autoformat')

" tmux integration
call dein#add('tmux-plugins/vim-tmux-focus-events')
call dein#add('roxma/vim-tmux-clipboard')

" languge dependent things
call dein#add('tmux-plugins/vim-tmux')
call dein#add('sheerun/vim-polyglot')
call dein#add('benekastah/neomake')
call dein#add('tomtom/tcomment_vim')
call dein#add('slashmili/alchemist.vim')
call dein#add('elixir-lang/vim-elixir')

" insights
call dein#add('wakatime/vim-wakatime')

" style
call dein#add('airblade/vim-gitgutter')
call dein#add('powerman/vim-plugin-AnsiEsc')
call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')
call dein#add('edkolev/tmuxline.vim')
"call dein#add('altercation/vim-colors-solarized')
"call dein#add('dracula/vim')
"call dein#add('sickill/vim-monokai')
"call dein#add('jpo/vim-railscasts-theme')
"call dein#add('NLKNguyen/papercolor-theme')
call dein#add('iCyMind/NeoSolarized')


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
syn enable
set foldmethod=marker
set termguicolors
set laststatus=2
set showtabline=2
set nocompatible
set number
set relativenumber
set numberwidth=3
set shiftwidth=4
set expandtab
set tabstop=4
set autoindent
set incsearch
autocmd VimEnter :set hlsearch<cr>
set nomore
set ruler
set visualbell
set ignorecase
set mouse=a
set encoding=utf8
set fileencoding=utf-8
autocmd VimEnter set encoding=utf-8
set completeopt-=preview
set timeoutlen=700
set colorcolumn=80
set cursorline
set confirm
set textwidth=80

" Let airline tell me my status
set noshowmode

" }}}

" Things run on save {{{
" format the autoformatter
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0

let g:formatdef_my_custom_perl = '"perltidy -q -st -se -i=4 -ci=4 -pt=2 -otr -sot -sct -nsfs -noll -nola"'
let g:formatters_perl = ['my_custom_perl']

" define neomake overrides
let g:neomake_perl_enabled_makers = ['perl']

" run the autoformatter first, then neomake
au BufWrite * :Autoformat
autocmd! BufWritePost * Neomake
" }}}

" Languages {{{
" Use deoplete.
let g:deoplete#enable_at_startup = 1
let g:neomake_open_list = 2

autocmd FileType javascript set colorcolumn=120

augroup AutoFold
    autocmd!
    autocmd FileType vim,lua,perl,elixir setlocal foldmethod=marker
augroup END

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
" }}}

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
map <esc> :noh<cr>

" }}}

" Theme {{{

" NeoMake error/warning
let g:neomake_error_sign = {'text': ''}
let g:neomake_warning_sign = {'text': ''}
call neomake#signs#RedefineErrorSign()
call neomake#signs#RedefineWarningSign()


" default value is "normal", Setting this option to "high" or "low" does use the
" same Solarized palette but simply shifts some values up or down in order to
" expand or compress the tonal range displayed.
let g:neosolarized_contrast = "normal"

" Special characters such as trailing whitespace, tabs, newlines, when displayed
" using ":set list" can be set to one of three levels depending on your needs.
" Default value is "normal". Provide "high" and "low" options.
let g:neosolarized_visibility = "low"

" I make vertSplitBar a transparent background color. If you like the origin solarized vertSplitBar
" style more, set this value to 0.
let g:neosolarized_vertSplitBgTrans = 1

" If you wish to enable/disable NeoSolarized from displaying bold, underlined or italicized
" typefaces, simply assign 1 or 0 to the appropriate variable. Default values:
let g:neosolarized_bold = 1
let g:neosolarized_underline = 1
let g:neosolarized_italic = 0

syntax on
" set background=light
set background=dark
" colorscheme solarized
" colorscheme PaperColor
colorscheme NeoSolarized
"}}}

" Airline/Tmuxline settings {{{
"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tmuxline#enabled = 1
let g:airline#extensions#tabline#show_tab_nr = 0

let g:airline_section_z = airline#section#create(['%{ObsessionStatus('''', '''')}', 'windowswap', '%3p%% ', 'linenr', ':%3v '])
let g:airline_theme='bubblegum'

if !exists('g:airline_symbols')
        let g:airline_symbols = {}
endif
" unicode symbols
let g:airline_powerline_fonts = 1
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols.linenr = '⌙'
let g:airline_symbols.crypt = ''
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.paste = ''
let g:airline_symbols.spell = ''
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = '…'"

let g:tmuxline_powerline_separators = 1
let g:tmuxline_preset = {
                        \'a'    : '#S',
                        \'c'    : '#(battery -t)',
                        \'win'  : ['#I', '#W'],
                        \'cwin' : ['#I', '#W', '#F'],
                        \'y'    : ['%R', '%a', '%Y'],
                        \'z'    : '#H'}
" }}}
