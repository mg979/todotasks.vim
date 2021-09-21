syn cluster TaskPriority contains=TaskCritical,TaskHigh,TaskMedium,TaskLow
syn cluster TaskText contains=TaskDoneText,TaskCanceledText,TaskDueText

syn match  TaskGroup         '^[[:alnum:][:blank:]]\+:$'
syn match  TaskTodoMark      '^\s*☐' contained nextgroup=TaskText
syn match  TaskCanceledMark  '^\s*✘' contained nextgroup=TaskText
syn match  TaskDoneMark      '^\s*✔' contained nextgroup=TaskText
syn region TaskLine          start='^\s*\%(✔\|✘\|☐\)' end=/$/ oneline contains=TaskTodoMark,TaskDoneMark,TaskCanceledMark,@TaskPriority,@TaskText
syn match  TaskDoneText      '.\{-}\zedone:.*' contained nextgroup=TaskDone contains=@TaskPriority
syn match  TaskArchivedText  '.\{-}\zearchived:.*' contained nextgroup=TaskArchived
syn match  TaskCanceledText  '.\{-}\zecanceled:.*' contained nextgroup=TaskCanceled contains=@TaskPriority
syn match  TaskDueText       '.\{-}\zedue:.*' contained nextgroup=TaskTodo contains=@TaskPriority
syn match  TaskTodo          'due\ze:' contained nextgroup=TaskDate
syn match  TaskDone          'done\ze:' contained nextgroup=TaskDate
syn match  TaskArchived      'archived\ze:' contained nextgroup=TaskDate
syn match  TaskCanceled      'canceled\ze:' contained nextgroup=TaskDate
syn match  TaskDate          '.*' contained
syn match  TaskCritical      '@critical\>'
syn match  TaskHigh          '@high\>'
syn match  TaskMedium        '@medium\>'
syn match  TaskLow           '@low\>'

let s:cs = map(split(&commentstring, '%s'), 'escape(v:val, "\\")')
exe 'syn region TaskComment start=/\V'. s:cs[0] .'/ end=/\V'. s:cs[1] .'/ fold contains=TaskArchived'

hi default link TaskGroup          Title
hi default link TaskTodo           Constant
hi default link TaskTodoMark       Delimiter
hi default link TaskDone           diffAdded
hi default link TaskArchived       Special
hi default link TaskDoneMark       diffAdded
hi default link TaskCanceled       WarningMsg
hi default link TaskCanceledMark   WarningMsg
hi default link TaskDate           Comment
hi default link TaskDoneText       PreProc
hi default link TaskArchivedText   PreProc
hi default link TaskCanceledText   Comment
hi default link TaskComment        Comment

fun! s:hi()
    if &bg == 'dark'
        hi default TaskCritical ctermbg=235 ctermfg=131 cterm=reverse guibg=#262626 guifg=#af5f5f gui=reverse
        hi default TaskHigh     ctermbg=235 ctermfg=208 cterm=reverse guibg=#262626 guifg=#ff8700 gui=reverse
        hi default TaskMedium   ctermbg=235 ctermfg=103 cterm=reverse guibg=#262626 guifg=#8787af gui=reverse
        hi default TaskLow      ctermbg=235 ctermfg=108 cterm=reverse guibg=#262626 guifg=#87af87 gui=reverse
    else
        hi default TaskCritical ctermbg=235 ctermfg=131 cterm=reverse guibg=#e0e0e0 guifg=#A63C93 gui=reverse
        hi default TaskHigh     ctermbg=235 ctermfg=208 cterm=reverse guibg=#e0e0e0 guifg=#CE3E42 gui=reverse
        hi default TaskMedium   ctermbg=235 ctermfg=103 cterm=reverse guibg=#e0e0e0 guifg=#8787af gui=reverse
        hi default TaskLow      ctermbg=235 ctermfg=108 cterm=reverse guibg=#e0e0e0 guifg=#87af87 gui=reverse
    endif
endfun

call s:hi()

augroup taskstodohi
    au!
    au ColorScheme * call s:hi()
augroup END
