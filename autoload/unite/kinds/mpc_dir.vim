let s:save_cpo = &cpo
set cpo&vim

let s:kind = {
\   'name' : 'mpc_dir',
\   'default_action' : 'ls',
\   'action_table': {},
\   'parents': ["mpc_music"],
\ }

let s:kind.action_table.ls= {
\   'is_selectable' : 0,
\   'is_invalidate_cache' : 1,
\   'description' : 'list all files/folders in directory',
\ }

function! s:kind.action_table.ls.func(candidate)  "{{{2
	call unite#start([["mpc","ls",a:candidate.word],])
endfunction

function! unite#kinds#mpc_dir#define()  "{{{2
    return s:kind
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
