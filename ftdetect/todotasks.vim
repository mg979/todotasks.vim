let s:fn = get(g:, 'todotasks_pattern', '*.TODO,TODO,*.todo')
exe 'autocmd BufNewFile,BufReadPost '. s:fn .' set filetype=todotasks'
