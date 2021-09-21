"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tasks
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab

setlocal commentstring=---%s---
setlocal fdm=syntax
setlocal foldtext=substitute(getline(v:foldstart),'^'.split(&commentstring,'%s')[0],'','')

nnoremap <buffer> gq         :update<bar>bdelete<cr>

inoremap <buffer> <C-\><C-\> ☐<space><space>

nnoremap <buffer> ,n         o☐<space><space>
nnoremap <buffer> ,w         :call <SID>task_due()<cr>
nnoremap <buffer> ,d         :call <SID>toggle_task_done()<CR>
nnoremap <buffer> ,c         :call <SID>toggle_task_canceled()<CR>
nnoremap <buffer> ,a         :call <SID>archive()<CR>
nnoremap <buffer> ,A         :call <SID>align()<cr>
nnoremap <buffer> K          :call <SID>notes()<cr>

nnoremap <buffer><expr> o    getline('.') =~ ':$' ? "o\t☐  " : getline('.') =~ '\v^\s*%(✘\|✔\|☐)' ? 'o☐  ' : 'o'
inoremap <buffer><expr> <cr> getline('.') =~ ':$' ? "\r\t☐  " : getline('.') =~ '\v^\s*%(✘\|✔\|☐)' ? "\r☐  " : "\r"

xnoremap <buffer><nowait> gc <esc>`>:put='---'<cr>`<:-put='---'<cr>A<space>
nnoremap <buffer><nowait> gco :set nofoldenable<cr>:put='---'<cr>:put='---'<cr>kA<space>

inoreabbrev <buffer> ,l @low
inoreabbrev <buffer> ,h @high
inoreabbrev <buffer> ,c @critical
inoreabbrev <buffer> ,m @medium

""
" Archive
""
fun! s:archive()
    if getline('.') !~ '^\s*[✔☐✘]'
        echo 'Not a task'
        return
    endif
    set nofoldenable
    let pos = getcurpos()
    let c = split(&commentstring, '%s')
    let a = search('^'. c[0] .' ARCHIVED')
    if a && a > pos[1]
        exe pos[1] . 'd'
        $put
        try
            s/\s\+\(due\|done\|canceled\):.*/\='  archived: '.strftime('%Y-%m-%d %H:%M')/
        catch
            $put ='  archived: '.strftime('%Y-%m-%d %H:%M')
            normal! kgJ
        endtry
    elseif a
        echo 'Task is already archived'
    else
        exe pos[1] . 'd'
        $
        put =''
        put =c[0] .' ARCHIVED'
        put
        try
            s/\s\+\(due\|done\|canceled\):.*/\='  archived: '.strftime('%Y-%m-%d %H:%M')/
        catch
            $put ='  archived: '.strftime('%Y-%m-%d %H:%M')
            normal! kgJ
        endtry
    endif
    call setpos('.', pos)
endfun

""
" Add notes to topic
""
fun! s:notes()
    let l = getline(".")
    let l = substitute(l, s:tags . '.*', '', '')
    let topic = matchstr(l, '^.\{-}\zs\w.*')
    drop .notes
    if line('$') == 1 && empty(getline(1))
        -put='# NOTES: '.fnamemodify(getcwd(), ':p:h:t')
    endif
    setfiletype markdown
    if !search(topic)
        silent $put=['', repeat('-', &tw), '', '## ' . topic, '', '']
        startinsert
    endif
endfun


""
" Add the 'due' tag
""
fun! s:task_due() abort
    if getline('.') =~ '^\s*✘'
        call s:toggle_task_canceled()
        redraw
        return s:task_due()
    elseif getline('.') =~ '^\s*✔'
        call s:toggle_task_done()
        redraw
        return s:task_due()
    elseif getline('.') !~ '^\s*☐'
        return
    endif
    let days = input('Date or days from now? ')
    if empty(days)
        return
    endif
    let hours = input('Which hour? ', '12')
    if empty(hours)
        return
    elseif hours =~ ':'
        let [hours, minutes] = split(hours, ':')
    else
        let minutes = 0
    endif
    silent! s/\s*due:.*//
    if days =~ '\.\|/'
        let h = (hours - 1) * 60 * 60 + minutes * 60
        s/\(.*\)/\=submatch(1).'    due: '.days.' '.strftime('%H:%M', h)/
    else
        let h = hours * 60 * 60 + minutes * 60
        let _h = strftime('%H') * 60 * 60
        let _m = strftime('%M') * 60
        let today = localtime() - _h - _m
        let d = days * 24 * 60 * 60
        let time = today + d + h
        s/\(.*\)/\=submatch(1).'    due: '.strftime('%Y-%m-%d %H:%M', time)/
    endif
endfun

""
" Add the 'done' tag
""
fun! s:toggle_task_done() abort
    if getline('.') =~ '^\s*☐.*due:'
        s/☐\(.\{-}\)\%(\s\+due:.*\)/\='✔'.submatch(1).'    done: '.strftime('%Y-%m-%d %H:%M')/
    elseif getline('.') =~ '^\s*☐'
        s/☐\(.*\)/\='✔'.submatch(1).'    done: '.strftime('%Y-%m-%d %H:%M')/
    elseif getline('.') =~ '^\s*✘'
        s/✘\(.\{-}\)\%(\s\+canceled:.*\)/\='✔'.submatch(1).'    done: '.strftime('%Y-%m-%d %H:%M')/
    elseif getline('.') =~ '^\s*✔.*done:'
        s/✔\(.\{-}\)\s\+done:.*/☐\1/
    endif
endfun

""
" Add the 'canceled' tag
""
fun! s:toggle_task_canceled() abort
    if getline('.') =~ '^\s*☐.*due:'
        s/☐\(.\{-}\)\%(\s\+due:.*\)/\='✘'.submatch(1).'    canceled: '.strftime('%Y-%m-%d %H:%M')/
    elseif getline('.') =~ '^\s*☐'
        s/☐\(.*\)/\='✘'.submatch(1).'    canceled: '.strftime('%Y-%m-%d %H:%M')/
    elseif getline('.') =~ '^\s*✔'
        s/✔\(.\{-}\)\%(\s\+done:.*\)/\='✘'.submatch(1).'    canceled: '.strftime('%Y-%m-%d %H:%M')/
    elseif getline('.') =~ '^\s*✘.*canceled:'
        s/✘\(.\{-}\)\s\+canceled:.*/☐\1/
    endif
endfun

""
" Align tasks tags
""
let s:tags = '\v\s*(due:|done:|canceled:|archived:|\@critical|\@high|\@medium|\@low)'

fun! s:align()
    let s:max = max(map(getline(1, '$'), 'match(v:val, s:tags)'))
    let txt = map(getline(1, '$'), 'substitute(v:val,
                \                              "\\s\\+\\ze". s:tags,
                \                              s:width(v:key + 1), "")')
    %d_
    -put=txt
    $d_
endfun

fun! s:width(line)
    let l = getline(a:line)
    let m = match(l, s:tags)
    return repeat(' ', s:max - m) . '   '
endfun
