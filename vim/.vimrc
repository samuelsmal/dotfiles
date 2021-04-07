set nocompatible              " be iMproved, required
set encoding=utf-8
set fenc=utf-8
set termencoding=utf-8

" Set map leader
let mapleader="\<Space>"
let maplocalleader="\<Space>\<Space>"

if filereadable(expand("~/.vim/vimrc.bundles"))
  source ~/.vim/vimrc.bundles
endif

let g:deoplete#enable_at_statup=1

let g:jsx_ext_required = 0 " Allow JSX in normal JS files
"
"vnoremap <silent> y y:call utils#ClipboardYank()<cr>
"vnoremap <silent> d d:call utils#ClipboardYank()<cr>
"nnoremap <silent> p :call utils#ClipboardPaste()<cr>p

syntax on                         " show syntax highlighting
filetype plugin indent on

set nu
set autoindent                    " set auto indent
set ts=2                          " set indent to 2 spaces
set shiftwidth=2
set mouse=a
set expandtab                     " use spaces, not tab characters
set relativenumber                " show relative line numbers
set showmatch                     " show bracket matches
set hlsearch                      " highlight all search matches
set cursorline                    " highlight current line
set ignorecase                    " ignore case in search
set smartcase                     " pay attention to case when caps are used
set incsearch                     " show search results as I type
set ttimeoutlen=100               " decrease timeout for faster insert with 'O'
set vb                            " enable visual bell (disable audio bell)
set ruler                         " show row and column in footer
set scrolloff=2                   " minimum lines above/below cursor
set laststatus=2                  " always show status bar
set list listchars=tab:»·,trail:· " show extra space characters
set nofoldenable                  " disable code folding
set clipboard=unnamedplus         " use the system clipboard
set wildmenu                      " enable bash style tab completion
set wildmode=list:longest,full
set showcmd                       " display incomplete commands

" Split behaviour
set splitbelow
set splitright

" Colouring split
"hi VertSplit ctermbg=bg ctermfg=fg
set fillchars+=vert:\|

" Automatically read a file that has changed on disk
set autoread

" Hide mouse pointer while typing
set mousehide

" Highlights columns
set colorcolumn=100
set textwidth=100

" Allow switching buffer even if current buffer contains unsaved changes
set hidden

" Set encryption method
set cm=blowfish2

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


set background=dark
"if strftime("%H") < 15 && strftime("%H") > 11
  "set background=light
"else
  "set background=dark
"endif
colorscheme solarized

" Correct filetype recognition
autocmd BufNewFile,BufRead *.md set filetype=markdown

" Toggle tagbar
nmap <F8> :TagbarToggle<CR>

" Sets vim backup and swap directory
set backupdir=.backup/,~/.backup/,/tmp//
set directory=.swp/,~/.swp/,/tmp//
set undodir=.undo/,~/.undo/,/tmp//

" no clue why it sometimes enters capitalised letter
command! Q q
command! W w

" ALE
let g:ale_sign_warning = '▲'
let g:ale_sign_error = '✗'
highlight link ALEWarningSign String
highlight link ALEErrorSign Title

" Lightline
let g:lightline = {
  \ 'colorscheme': 'solarized',
  \ 'active': {
  \   'left': [['mode', 'paste'], ['filename', 'modified']],
  \   'right': [['lineinfo'], ['percent'], ['readonly', 'linter_warnings', 'linter_errors', 'linter_ok']]
  \ },
  \ 'component_expand': {
  \   'linter_warnings': 'LightlineLinterWarnings',
  \   'linter_errors': 'LightlineLinterErrors',
  \   'linter_ok': 'LightlineLinterOK'
  \ },
  \ 'component_type': {
  \   'readonly': 'error',
  \   'linter_warnings': 'warning',
  \   'linter_errors': 'error'
  \ },
  \ }

function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ◆', all_non_errors)
endfunction

function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
endfunction

function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '✓ ' : ''
endfunction

autocmd User ALELint call s:MaybeUpdateLightline()

let g:ale_linters = {
      \ 'javascript': ['standard'],
      \}
let g:ale_fixers = {'javascript': ['standard']}
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1

au BufRead,BufNewFile *.js setlocal iskeyword-=.
au FileType js setlocal iskeyword-=.

" Update and show lightline but only if it's visible (e.g., not in Goyo)
function! s:MaybeUpdateLightline()
  if exists('#lightline')
    call lightline#update()
  end
endfunction

" Turns on spell check for certain files
autocmd FileType latex,markdown setlocal spell spelllang=en_gb
autocmd BufRead,BufNewFile *.tex setlocal spell spelllang=en_gb
set spellsuggest=best,10

" highlight the status bar when in insert mode
if version >= 700
  au InsertEnter * hi StatusLine ctermfg=235 ctermbg=2
  au InsertLeave * hi StatusLine ctermbg=240 ctermfg=12
endif

" Switch 0 with ^
noremap 0 ^ " go the first non-blank character of the line
noremap ^ 0 " go the beginning of the line

" bind K to grep word under cursor
map <Leader>k :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" RSpec.vim mappings
"map <Leader>c :call RunCurrentSpecFile()<CR>
"map <Leader>s :call RunNearestSpec()<CR>
"map <Leader>l :call RunLastSpec()<CR>
"map <Leader>a :call RunAllSpecs()<CR>

" NERDTree mappings
map <Leader>n :NERDTreeToggle<CR>

" syntastic settings
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

" Fixes conda path changes
let g:ycm_path_to_python_interpreter = '/usr/bin/python'

" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 0
" let g:syntastic_check_on_open = 0
" let g:syntastic_check_on_wq = 1
"
" let g:syntastic_enable_signs = 1
" let g:syntastic_style_error_symbol = "✗"
" let g:syntastic_style_warning_symbol = "⚠"
"
" let g:syntastic_python_checkers = ['pylint']
" let g:syntastic_javascript_checkers = ['standard']
" let g:syntastic_ruby_checkers   = ['rubocop']

" map <Leader>ly :call SyntasticCheck()<CR>


" python

vmap <leader>r :w !python<CR>
nmap <leader>r :w !python % <CR>


" Vim fugitive
map <Leader>gs :Gstatus<CR>
map <Leader>gc :Gcommit<CR>
map <Leader>gp :Gpush<CR>
map <Leader>gb :Gblame<CR>
map <Leader>gl :Glog<CR>

" close split but don't close window
" https://stackoverflow.com/questions/4298910/vim-close-buffer-but-not-split-window
nmap ,d :b#<bar>bd#<CR>

let NERDTreeQuitOnOpen=1

" Search and replace word under cursor (,*)
nnoremap <leader>* :%s/\<<C-r><C-w>\>//<Left>

" Strip trailing whitespace (,ss)
noremap <leader>ss :call utils#StripTrailingWhitespace()<CR>

" rainbow parenthesis
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" Tabularize
if exists(":Tabularize")
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:\zs<CR>
  vmap <Leader>a: :Tabularize /:\zs<CR>
endif

" Closes scratch
autocmd CompleteDone * pclose

" 1) search with /something
" 2) hit cs, replace first match, hit <Esc>
" 3) hit n.n.n.n. reviewing and replacing all matches
vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
    \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
omap s :normal vs<CR>

nnoremap <Leader>w :w<CR>

" Insert current time
:nnoremap <Leader>t "=strftime("%Y-%m-%d %H:%M:%S")<CR>P

" Toggle Tabulize
"inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

" RainbowParentheses for Solarized Theme
" Credits to:
" http://www.deepbluelambda.org/programming/clojure/programming-clojure-with-vim-2013-edition
let g:rbpt_colorpairs = [
  \ [ '13', '#6c71c4'],
  \ [ '5',  '#d33682'],
  \ [ '1',  '#dc322f'],
  \ [ '9',  '#cb4b16'],
  \ [ '3',  '#b58900'],
  \ [ '2',  '#859900'],
  \ [ '6',  '#2aa198'],
  \ [ '4',  '#268bd2'],
  \ ]

" Rainbow Parens
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['blue',        'RoyalBlue3'],
    \ ['green',      'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]

" ctrlp
nnoremap <Leader>o :CtrlP<CR>
let g:ctrl_working_path_mode = 'ra'

if executable('ag')
  " Use ag over grep
  let g:ackprg = 'ag --vimgrep'
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l -g ""'
  " ag is fast enough
  let g:ctrlp_use_caching = 0

  " ack.vim
  let g:ackprg = 'ag --vimgrep'
else
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
  "let g:ctrlp_user_command = {
  "  \ 'types': {
  "    \ 1: ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard'],
  "    \ 2: ['.ctrlpignore', 'find %s -type f | grep -v "`cat .ctrlpignore`"'],
  "    \ },
  "  \ 'fallback': 'find %s -type f'
  "  \ }
endif

" let g:ycm_path_to_python_interpreter = '/usr/bin/python3'

" ultisnips
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
" ultisnips end

nnoremap ** :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=4000
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=500
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction

" XML
augroup XML
    autocmd!
    autocmd FileType xml setlocal foldmethod=indent foldlevelstart=999 foldminlines=0
augroup END
let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax


function XMLFormat()
  %!xmllint --format %
endfunction

let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax

" XML End

set wildignore+=*/tmp/*,*.so,*.swp,*.zip
set runtimepath^=~/.vim/bundle/ctrlp.vim
