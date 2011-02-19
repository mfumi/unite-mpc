let s:save_cpo = &cpo
set cpo&vim

let s:kind = {
\   'name' : 'mpc_lyrics_fetchable',
\   'default_action' : 'fetch_lyrics',
\   'action_table': {},
\   'parents': [],
\ }


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

function! unite#kinds#mpc_lyrics_fetchable#define()  "{{{2
    return s:kind
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
