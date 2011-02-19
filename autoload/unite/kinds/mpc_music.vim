let s:save_cpo = &cpo
set cpo&vim

let s:kind = {
\   'name' : 'mpc_music',
\   'default_action' : 'add',
\   'action_table': {},
\   'parents': ["mpc_lyrics_fetchable"],
\ }

let s:kind.action_table.ls_parent = {
\   'is_selectable' : 0,
\   'description' : 'list all files/folders in parent directory'
\ }

function! s:kind.action_table.ls_parent.func(candidate)  "{{{2
    if has('win32') || has('win64')
        let dir = join(split(a:candidate.action__name,'\\')[:-3],'\\')
    else
        let dir = join(split(a:candidate.action__name,'/')[:-3],'/')
    endif
    call unite#start([["mpc","ls",'"'.dir.'"'],])
endfunction

let s:kind.action_table.add = {
\   'is_selectable' : 1,
\   'is_quit' : 0,
\   'is_invalidate_cache' : 0,
\   'description' : 'add music(s) to current playlist',
\ }

function! s:kind.action_table.add.func(candidates)  "{{{2
    echo "\n"
    for c in a:candidates
        call system('mpc add "'.c.action__name.'"')
        echo "add to playlist : ".c.word
    endfor
endfunction

let s:kind.action_table.add_entire_dir = {
\   'is_selectable' : 0,
\   'is_quit' : 0,
\   'is_invalidate_cache' : 0,
\   'description' : 'add all musics in entire directory to current playlist',
\ }

function! s:kind.action_table.add_entire_dir.func(candidate)  "{{{2
    echo "\n"
    if has('win32') || has('win64')
        let dir = join(split(a:candidate.action__name,'\\')[:-2],'\\')
    else
        let dir = join(split(a:candidate.action__name,'/')[:-2],'/')
    endif
    call system('mpc add "'.dir.'"')
    echo "add to playlist : ".dir
endfunction

let s:kind.action_table.fetch_lyrics = {
\   'is_selectable' : 1,
\   'is_quit' : 0,
\   'is_invalidate_cache' : 0,
\   'description' : 'fetch lyrics',
\ }

function! s:kind.action_table.fetch_lyrics.func(candidates)  "{{{2
    if exists("*Fetch_lyrics") == 0
        echo "not supported"
        return
    endif
    for c in a:candidates
        if has_key(c,"action__artist")
            let artist = c.action__artist
            let title  = c.action__title
        else 
            let word = split(c.word,' - ')
            if len(word) == 2
                let artist = word[0]
                let title = word[1]
            else
                continue
            endif
        endif
        call Fetch_lyrics(artist,title)
    endfor
endfunction
function! unite#kinds#mpc_music#define()  "{{{2
    return s:kind
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
