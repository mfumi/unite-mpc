let s:save_cpo = &cpo
set cpo&vim

let s:kind = {
\   'name' : 'mpc_back',
\   'default_action' : 'back',
\   'action_table': {},
\   'parents': [],
\ }

let s:kind.action_table.back = {
\   'is_selectable' : 0,
\   'description' : 'back'
\ }

function! s:kind.action_table.back.func(candidate)  "{{{2
    if has_key(a:candidate,"action__arg")
        call unite#start([["mpc",a:candidate.action__cmd,a:candidate.action__arg],])
    else
        call unite#start([["mpc",a:candidate.action__cmd],])
    endif
endfunction

function! unite#kinds#mpc_back#define()  "{{{2
    return s:kind
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
