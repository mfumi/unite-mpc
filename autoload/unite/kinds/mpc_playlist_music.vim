let s:save_cpo = &cpo
set cpo&vim

let s:kind = {
\   'name' : 'mpc_playlist_music',
\   'default_action' : 'play',
\   'action_table': {},
\   'parents': ["mpc_lyrics_fetchable"],
\ }

let s:kind.action_table.delete = {
\   'is_selectable' : 1,
\   'is_quit' : 0,
\   'is_invalidate_cache' : 1,
\   'description' : 'delete music(s) from playlist',
\ }

function! s:kind.action_table.delete.func(candidates)  "{{{2
    let delete_num = [] 
    for c in a:candidates
        call add(delete_num,c.action__num)
    endfor
    call system("mpc del ".join(delete_num,' '))
endfunction

let s:kind.action_table.play = {
\   'is_selectable' : 0,
\   'is_quit' : 0,
\   'description' : 'play music',
\ }

function! s:kind.action_table.play.func(candidate)  "{{{2
    call system("mpc play ".a:candidate.action__num)
    echo "Playing: ".a:candidate.word
endfunction


function! unite#kinds#mpc_playlist_music#define()  "{{{2
  return s:kind
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
