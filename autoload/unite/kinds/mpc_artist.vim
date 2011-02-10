let s:save_cpo = &cpo
set cpo&vim

let s:kind = {
\   'name' : 'mpc_artist',
\   'default_action' : 'ls',
\   'action_table': {},
\   'parents': [],
\ }

let s:kind.action_table.ls = {
\   'is_selectable' : 0,
\   'description' : 'list all album'
\ }

function! s:kind.action_table.ls.func(candidate)  "{{{2
    call unite#start([["mpc","artist",a:candidate.word],])
endfunction

let s:kind.action_table.add = {
\   'is_selectable' : 1,
\   'is_quit' : 0,
\   'is_invalidate_cache' : 1,
\   'description' : 'add all music to current playlist',
\ }

function! s:kind.action_table.add.func(candidates)  "{{{2
    echo "\n"
    for c in a:candidates
        call system('mpc find Artist "'.c.word.'" | mpc add')
        echo "add to playlist , Artist : ".c.word
    endfor
endfunction

function! unite#kinds#mpc_artist#define()  "{{{2
    return s:kind
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
