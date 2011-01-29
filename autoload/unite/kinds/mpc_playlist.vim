let s:save_cpo = &cpo
set cpo&vim

let s:kind = {
\   'name' : 'mpc_playlist',
\   'default_action' : 'load',
\   'action_table': {},
\   'parents': [],
\ }

let s:kind.action_table.load = {
\   'is_selectable' : 1,
\   'is_quit' : 0,
\   'is_invalidate_cache' : 1,
\   'description' : 'load playlist',
\ }

function! s:kind.action_table.load.func(candidates)  "{{{2
    echo "\n"
    for c in a:candidates
        call system('mpc load "'.c.word.'"')
        echo "Loading: ".c.word
    endfor
endfunction

function! unite#kinds#mpc_playlist#define()  "{{{2
    return s:kind
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
