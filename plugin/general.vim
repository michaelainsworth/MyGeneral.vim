" =============================================================================
" General VIM Enhancements
" =============================================================================

" This file contains my general enhancements to vim.
" 
" These enhacements are not related to a particular task or file type.

" -----------------------------------------------------------------------------
" Git
" -----------------------------------------------------------------------------

" Creates a new tab, filled with the contents of `git diff --staged`.
" 
" This is useful for working out what you're about to commit.
function! s:GitDiffStaged()
    tabe | setfiletype diff | r !git diff --staged
endfunction

command! GitDiffStaged :call <SID>GitDiffStaged()
command! Gds :call <SID>GitDiffStaged()

" Writes the current buffer to the command 'git commit', then closes the
" current buffer.
function! s:GitCommit()
    w !git commit -F -
    q!
endfunction

command! GitCommit :call <SID>GitCommit()
command! Gc :call <SID>GitCommit()

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

" Changes files beginning with ^pick to 'squash'.
function! s:GitSquash()
    if &filetype != 'gitrebase'
        return
    endif

    2,$s/^pick/squash/g
endfunction
command! GitSquash :call <SID>GitSquash()

" Formats a page ready for commit.
function! s:GitFormat()
    setfiletype gitcommit
    let l:old_textwidth = &textwidth

    set textwidth=50
    normal gg
    normal gqq
    normal j

    set textwidth=72
    gqG

    let &textwidth = l:old_textwidth
endfunction

command! GitFormat :call <SID>GitFormat()
command! Gf :call <SID>GitFormat()

