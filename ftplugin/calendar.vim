if exists("b:did_ftplugin") && b:did_ftplugin != 1
  finish
endif
let b:did_ftplugin = 1

function! s:lpad(str)
    let l:str = a:str
    while strlen(l:str) < 2
        let l:str = '0' . l:str
    endwhile
    return l:str
endfunction

function! s:SID()
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfunction

function! s:DoInsert(day,month,year,week,dir)
    " Stop if we're not on a number.
    if a:week == -1
        return
    endif

    let l:day = <SID>lpad(a:day)
    let l:month = <SID>lpad(a:month)

    let l:week = ''
    if a:week == 1
        let l:week = 'Mon'
    elseif a:week == 2
        let l:week = 'Tue'
    elseif a:week == 3
        let l:week = 'Wed'
    elseif a:week == 4
        let l:week = 'Thu'
    elseif a:week == 5
        let l:week = 'Fri'
    elseif a:week == 6
        let l:week = 'Sat'
    elseif a:week == 7
        let l:week = 'Sun'
    endif

    let l:str = l:week . ' ' . a:year . '-' . l:month . '-' . l:day

    let l:old = @"
    let @" = l:str
    normal! 
    put 
    let @" = l:old
endfunction

function! s:Insert()
    let l:old = g:calendar_action
    let l:prefix = <SID>SID()
    let g:calendar_action = '<SNR>' . l:prefix . '_DoInsert'
    normal 
    let g:calendar_action = l:old
endfunction

" Insert current timestamp.
nnoremap <leader>i :call <SID>Insert()<cr>
