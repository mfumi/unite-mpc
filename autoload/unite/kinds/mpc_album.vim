let s:save_cpo = &cpo
set cpo&vim

let s:kind = {
\   'name' : 'mpc_album',
\   'default_action' : 'ls',
\   'action_table': {},
\   'parents': [],
\ }

let s:kind.action_table.ls = {
\   'is_selectable' : 0,
\   'description' : 'list music'
\ }

function! s:kind.action_table.ls.func(candidate)  "{{{2
    call unite#start([["mpc","artist",
                      \a:candidate.action__artist,
                      \a:candidate.word],])
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
        call system('mpc find Artist "'.c.action__artist.
                    \'" Album "'.c.word.'" | mpc add')
        echo "add to playlist  : ".c.word
    endfor
endfunction

function! unite#kinds#mpc_album#define()  "{{{2
    return s:kind
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
