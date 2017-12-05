" =============================================================================
" GENERAL VIM ENHANCEMENTS
"
" This file contains my general enhancements to vim.
" 
" These enhacements are not related to a particular task or file type.
" =============================================================================

" GENERAL {{{ ---------------------------------------------------------------

" Set the leader to spacebar.
let g:mapleader = ' '
let g:maplocalleader = ' '

" By default, the current path is the current working directory (recursively
" searched).
set path=$PWD/**

" Set the timeout for characters and keys.
set timeout
set ttimeout
set timeoutlen=400
set ttimeoutlen=400

" Enable syntax hilighting.
syntax on

" Always display line numbers.
set number

" Tabbing
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab

" Ruler at 80 characters
set colorcolumn=80

" ------------------------------------------------------------------------- }}}

" MAPPINGS {{{ ----------------------------------------------------------------

" Input-to-normal mode
inoremap jj <esc>

" Toggle relative numbers.
nnoremap <leader>r :set relativenumber!<cr>

" Sort the selected lines.
vnoremap <leader>s :!sort -u<cr>

" Trim the selected lines to 80 characters long.
vnoremap <leader>t :normal 80\|D<cr>

" lc means "last change".
onoremap <silent> lc :<c-u>normal '[V']<cr>
vnoremap <silent> lc <esc>`[V`]

" Quick saving/quitting
nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>
nnoremap <leader>qq :q!<cr>
nnoremap <leader>wq :wq<cr>
nnoremap <leader>wqq :wq!<cr>

" Quickly closing buffers.
nnoremap <leader>bd :bd<cr>
nnoremap <leader>bdd :bd!<cr>
nnoremap <leader>bw :bw<cr>
nnoremap <leader>bww :bw!<cr>

" Open NERDTree.
nnoremap <leader>f :NERDTree<cr>

" Split the windows.
nnoremap <leader>sv :vs<cr>
nnoremap <leader>sh :sp<cr>

" Open new windows.
nnoremap <leader>nv :vnew<cr>
nnoremap <leader>nh :new<cr>

" Previous/next buffers
nnoremap <leader>n :bn<cr>
nnoremap <leader>p :bp<cr>

" Window navigation
nnoremap <leader>h <c-w><c-h>
nnoremap <leader>j <c-w><c-j>
nnoremap <leader>k <c-w><c-k>
nnoremap <leader>l <c-w><c-l>

" Window resizing (this is an ALT key in urxvt).
nnoremap j <c-w>+
nnoremap k <c-w>-
nnoremap h <c-w><
nnoremap l <c-w>>

" Quick way to insert one character.
nnoremap <leader>i i_<esc>r
nnoremap <leader>a a_<esc>r

" Navigate tabes
nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>
nnoremap <leader>tn :tabe<cr> 
nnoremap <leader>te :tabe 

" Navigate quick fix list
nnoremap ]q :cnext<cr>
nnoremap [q :cprevious<cr>

" Navigate location list.
nnoremap ]w :lnext<cr>
nnoremap [w :lprevious<cr>
 
" Toggle paste mode.
nnoremap <leader>- :set paste!<cr>

" Paste from system clipboard.
nnoremap <leader>+ :set paste<cr>"+p:set nopaste<cr>:echo "Pasted"<cr>

" ------------------------------------------------------------------------- }}}

" PLUGINS {{{ -----------------------------------------------------------------

" Always display the status line, even when there's only
" one file open.
set laststatus=2

" This is required for the lightline plugin to render in colour in a GUI.
if !has('gui_running')
    set t_Co=256
endif

" Don't display the mode (e.g., '-- INSERT --') because it's already shown
" by the lightline plugin.
set noshowmode

" right was line-endings, encoding, filetype, percent, line:col

let g:lightline = {
    \ 'active': {
    \   'left': [ [ 'mode', 'paste'],
    \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
    \   'right': [ [ 'lineinfo' ],
    \              [ 'percent' ],
    \              [ 'fileformat', 'fileencoding', 'filetype', 'charvaluehex' ] ]
    \ },
    \ 'component': {
    \   'charvaluehex': '0x%B'
    \ },
    \ 'component_function': {
    \   'gitbranch': 'fugitive#head'
    \ }
    \ }

" Use a specific path for my wiki.
let g:vimwiki_list = [{'path':'~/Files/Organisation/source/',
    \ 'path_html':'~/Files/Organisation/build/'}]

" Use control-j to expand snippets.
let g:UltiSnipsExpandTrigger="<c-j>"

" Use python2 for the YCM server.
let g:ycm_server_python_interpreter = '/usr/bin/python2'

" Go to the definition/declaration of the function.
nnoremap <leader>gg :YcmCompleter GoToDefinitionElseDeclaration<cr>

if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
" ------------------------------------------------------------------------- }}}

" FILE MANAGEMENT {{{ ---------------------------------------------------------
" TODO: Perhaps this could be replaced with, e.g., nerd tree?
" Find the file under the current W word.
function! FindFile()
    find <cWORD>
endfunction
nnoremap <Leader>/ :call FindFile()<CR>
command! FindFile :call FindFile()

" Delete all buffers but the current one
function! DeleteOtherBuffers()
    let l:buffer = expand('%')
    execute 'bufdo bd'
    execute 'e ' . l:buffer
endfunction
command! DeleteOtherBuffers :call DeleteOtherBuffers()
 
function! VSplitAndFind(file)
    vs
    let l:command = "find "
    let l:command .= a:file
    execute l:command
endfunction
command! -nargs=1 -complete=file_in_path Vsf :call VSplitAndFind(<f-args>)

function!   QuickFixOpenAll()
    if empty(getqflist())
        return
    endif
    let s:prev_val = ""
    for d in getqflist()
        let s:curr_val = bufname(d.bufnr)
        if (s:curr_val != s:prev_val)
            execute "edit " . s:curr_val
        endif
        let s:prev_val = s:curr_val
    endfor
endfunction
command! QuickFixOpenAll         call QuickFixOpenAll()

" This function clears all the writable registers.
function! ClearRegisters()
    let l:regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-*+/', '\zs')
    for l:r in l:regs
        let l:command = 'let @' . l:r . ' = ""'
        execute l:command
    endfor
endfunction
command! ClearRegisters :call ClearRegisters()
" ------------------------------------------------------------------------- }}}

" GIT {{{ ---------------------------------------------------------------------

" The GitDiff function ceates a new tab, filled with the contents of
" `git diff`. This is useful for working out what you're about to commit.
function! s:GitDiff(against)
    tabe
    setlocal filetype=diff
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile

    let l:cmd  = '0read !'
    let l:cmd .= 'git diff '
    let l:cmd .= shellescape(a:against)

    execute l:cmd
    normal gg
endfunction
command! -nargs=1 GitDiff :call <SID>GitDiff(<args>)
command! -nargs=1 Gd :call <SID>GitDiff(<args>)
command! GitDiffStaged :call <SID>GitDiff('--staged')
command! Gds :call <SID>GitDiff('--staged')

" Opens a new scatch tab containing all the lines in the current branch 
" containing 'todo' that have been added since master.
"
" This function also maps <cr> to allow you to jump to that file.
function! s:GitTodo(against)
    tabe
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile

    normal ggO# Press enter to search for the todo item specified.

    let l:command  = 'read !'
    let l:command .= 'git diff ' . a:against . ' | '
    let l:command .= 'grep -e ^diff -e ^+'
    execute l:command

    let l:filter  = ".!grep -i todo | "
    let l:filter .= "sed -e 's/^.//g' "
    let l:filter .= "    -e 's/^\s\+//g' "
    let l:filter .= "    -e 's/^[*\\\#\/]\+//g' "
    let l:filter .= "    -e 's/^ \?@\?TODO:\? //gI'"

    global /^+/execute l:filter

    nnoremap <buffer> <cr> :call <SID>GitTodoFind()<cr>
endfunction
command! -nargs=? GitTodo :call <SID>GitTodo(<args>)
command! -nargs=? Gt :call <SID>GitTodo(<args>)

" An internal function used by GitTodo.
function! s:GitTodoFind()
    let l:old_register = @"
    normal 0v$hyy
    let l:search = @"
    let @" = l:old_register

    let l:command = 'grep -rHnF ' . shellescape(l:search) . ' .'
    tabe
    execute l:command
endfunction

" Writes the current buffer to the command 'git commit -F -'.
function! s:GitCommit()
    w !git commit -F -
    q!
endfunction
command! GitCommit :call <SID>GitCommit()
command! Gc :call <SID>GitCommit()

" Changes files beginning with ^pick to 'squash'.
function! s:GitSquash()
    if &filetype != 'gitrebase'
        return
    endif

    2,$s/^pick/squash/g
endfunction
command! GitSquash :call <SID>GitSquash()
" ------------------------------------------------------------------------- }}}

