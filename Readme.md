# todotasks.vim

Inspired by Sublime Text's Plain Tasks plugin.

All tasks must stay in a line, so it's not for verbose lists. If you need to
add details, you can press `K` on a task and it will open a new file
`.todonotes`, where you can write what you want.

Options:

`g:todotasks_pattern`: default is `.todo`


Normal mode mappings:

|||
|----------|----------|
|gq        | save and quit         |
|,n        | new task line         |
|,t        | due tag               |
|,d        | done tag              |
|,c        | canceled tag          |
|,a        | archive task          |
|,A        | align task tags       |
|,u        | remove priorities     |
|,U        | ,, and realign        |
|K         | open topic in .todonotes       |
|gK        | just open .todonotes  |
|gco       | add a comment section |


Insert mode abbreviations:

|||
|----------|----------|
| ,l       | @low priority tag       |
| ,h       | @high priority tag      |
| ,c       | @critical priority tag  |
| ,m       | @medium priority tag    |


An example:

