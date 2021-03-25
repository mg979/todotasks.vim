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
syn region TaskComment       start=/^\/\*/ end=/\*\// fold contains=TaskArchived

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
hi default TaskCritical ctermbg=9 ctermfg=15 guibg=Red guifg=White
hi default TaskHigh     ctermbg=13 ctermfg=15 guibg=Magenta guifg=White
hi default TaskMedium   ctermbg=11 ctermfg=0 guibg=Yellow guifg=Black
hi default TaskLow      ctermbg=10 ctermfg=15 guibg=Green guifg=White
