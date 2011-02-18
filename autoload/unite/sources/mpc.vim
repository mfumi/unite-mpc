let s:save_cpo = &cpo
set cpo&vim

let s:source = { 
\   'name': 'mpc',
\ }

function! s:source.gather_candidates(args, context)
    if len(a:args) > 0 
        if index([
                    \"playlist",
                    \"ls",
                    \"lsplaylists",
                    \"listall",
                    \"artist",
                    \]
                    \,a:args[0]) != -1
            let cmd = a:args[0]
        else
            echoerr "Unite mpc: invalid arg"
            return [{"word":"","source":""}]
        endif
    else
        let cmd = "listall"
    endif

    if cmd == "playlist"
        
        let r = split(system('echo "playlistinfo\nclose"| nc '
                        \.g:mpd_host.' '.g:mpd_port),"\n")[1:-2]
        
        let i = 0
        let info = [{}]
        
        for line  in r
            let [k,v] = split(line,": ")
            let info[i][k] = v
            if k == "Id"
                let i += 1
                call add(info,{})
            endif
        endfor

        unlet i
        let candidates = []

        for i in range(len(info)-1)
            let info_ = info[i]
            let word = s:padding(info_["Id"],5)

            if has_key(info_,"Title")
                let word .= s:padding(has_key(info_,"Artist") ? 
                                    \"  ".info_["Artist"]:"",30)
                let word .= s:padding(has_key(info_,"Title") ? 
                                    \"  ".info_["Title"]:"",40)
                let word .= s:padding(has_key(info_,"Album") ? 
                                    \"  ".info_["Album"]:"",40)
                let word .= s:padding(has_key(info_,"Track") ? 
                                    \"   ".info_["Track"]:"",8)
                let word .= s:padding(has_key(info_,"Date") ? 
                                    \" (".info_["Date"].")":"",8)
                if has_key(info_,"Time")
                    let time = info_["Time"]
                    let min = time / 60
					let min = len(min) == 1 ? " ".min : min
                    let sec = time % 60
					let sec = len(sec) == 1 ? "0".sec : sec
					let time = min.":".sec
                else 
                    let time = ""
                endif
                let word .= "  ".s:padding(time,5)
                if has_key(info_,"Genre")
                    let word .= "  ".info_["Genre"]
                endif
            else
                let word = simplify(info_["file"])
            endif

            let candidate = {}
            let candidate["word"] = word
            let candidate["source"] = "mpc"
            let candidate["kind"] = "mpc_playlist_music"
            let candidate["action__num"] = i+1
            call add(candidates,candidate)
        endfor

        return candidates

    elseif cmd == "lsplaylists"
        return map(split(system('mpc lsplaylists'), "\n"), '{
            \ "word": v:val,
            \ "source": "mpc",
            \ "kind": "mpc_playlist",
            \ "action__num": v:key+1,
            \ }')

    elseif cmd == "artist"
        if len(a:args) > 2
            return map(split(system('mpc find Artist "'.a:args[1].'"'
                \.' Album "'.a:args[2].'"'), "\n"), '{
                \ "word": v:val,
                \ "source": "mpc",
                \ "kind": "mpc_music",
                \ "action__num": v:key+1,
                \ "action__artist":  a:args[1],
                \ "action__album":  a:args[2],
                \ }')
        elseif len(a:args) > 1
            return map(split(system('mpc list Album Artist "'.a:args[1].'"'
                \),"\n"), '{
                \ "word": v:val,
                \ "source": "mpc",
                \ "kind": "mpc_album",
                \ "action__num": v:key+1,
                \ "action__artist":  a:args[1],
                \ }')
        else
            return map(split(system('mpc list Artist'), "\n"), '{
                \ "word": v:val,
                \ "source": "mpc",
                \ "kind": "mpc_artist",
                \ "action__num": v:key+1,
                \ }')
        endif

    elseif cmd == "ls"
        if len(a:args) > 1
            let dir = a:args[1]
        else
            let dir = ""
        endif

        return map(split(system('mpc ls "'.dir.'"'), "\n"), '{
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

    else  "listall
        return map(split(system('mpc '.cmd), "\n"), '{
            \ "word": v:val,
            \ "source": "mpc",
            \ "kind": "mpc_music",
            \ }')
    endif
endfunction

function! s:padding(str,width)
    if v:version >= 703
        if strwidth(a:str) > a:width 
            let str = s:trim(a:str,a:width-3)."..."
            let str = str.repeat(' ',a:width-strwidth(str))
        else
            let str = a:str.repeat(' ',a:width-strwidth(a:str))
        endif   
    else
        if len(a:str) > a:width
            let str =  a:str[:a:width-1]
        else
            let str = a:str.repeat(' ',a:width-len(a:str))
        endif
    endif
    return str
endfunction

" Trim string after a:n display cells.
" thanks: tyru [https://gist.github.com/833618]
function! s:trim(s, n)
    let s = ''
    for c in split(a:s, '\zs')
        if strwidth(s . c) > a:n
            return s
        endif
        let s .= c
    endfor
    return s
endfunction

function! unite#sources#mpc#define()
    if !exists('g:mpd_host')
        let g:mpd_host = "localhost"
    endif
    if !exists('g:mpd_port')
        let g:mpd_port = "6600"
    endif
    return executable('mpc') ? [s:source] : []
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
