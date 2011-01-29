let s:save_cpo = &cpo
set cpo&vim

let s:source = { 
\   'name': 'mpc',
\ }

function! s:source.gather_candidates(args, context)
    if len(a:args) > 0 
        if index(["playlist","ls","lsplaylists","listall"],a:args[0]) != -1
            let cmd = a:args[0]
        else
            echoerr "Unite mpc: invalid arg"
            return [{"word":"","source":""}]
        endif
    else
        let cmd = "listall"
    endif

    if cmd == "playlist"
        return map(split(system('mpc '.cmd), "\n"), '{
            \ "word": v:val,
            \ "source": "mpc",
            \ "kind": "mpc_playlist_music",
            \ "action__num": v:key+1,
            \ }')
    elseif cmd == "lsplaylists"
        return map(split(system('mpc '.cmd), "\n"), '{
            \ "word": v:val,
            \ "source": "mpc",
            \ "kind": "mpc_playlist",
            \ "action__num": v:key+1,
            \ }')
    elseif cmd == "ls"
        if len(a:args) > 1
            let dir = a:args[1]
        else
            let dir = ""
        endif
        let cmd = cmd." ".dir
    endif
    " cmd is ls or listall
    return map(split(system('mpc '.cmd), "\n"), '{
        \ "word": v:val,
        \ "source": "mpc",
        \ "kind":
        \ v:val =~ ".mp3$" || 
        \ v:val =~ ".m4a$" || 
        \ v:val =~ ".ogg$" ||
        \ v:val =~ ".wav$" || 
        \ v:val =~ ".flac$" ? 
        \ "mpc_music" : "mpc_dir"
        \ }')
endfunction

function! unite#sources#mpc#define()
    return executable('mpc') ? [s:source] : []
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
