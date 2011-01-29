let s:save_cpo = &cpo
set cpo&vim

let s:kind = {
\   'name' : 'mpc_music',
\   'default_action' : 'add',
\   'action_table': {},
\   'parents': [],
\ }

let s:kind.action_table.ls_parent = {
\   'is_selectable' : 0,
\   'description' : 'list all files/folders in parent directory'
\ }

function! s:kind.action_table.ls_parent.func(candidate)  "{{{2
    if has('win32') || has('win64')
        let dir = join(split(a:candidate.word,'\\')[:-3],'\\')
    else
        let dir = join(split(a:candidate.word,'/')[:-3],'/')
    endif
    call unite#start([["mpc","ls",'"'.dir.'"'],])
endfunction

let s:kind.action_table.add = {
\   'is_selectable' : 1,
\   'is_quit' : 0,
\   'is_invalidate_cache' : 1,
\   'description' : 'add music(s) to current playlist',
\ }

function! s:kind.action_table.add.func(candidates)  "{{{2
    echo "\n"
    for c in a:candidates
        call system('mpc add "'.c.word.'"')
        echo "add to playlist : ".c.word
    endfor
endfunction

function! unite#kinds#mpc_music#define()  "{{{2
    return s:kind
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
