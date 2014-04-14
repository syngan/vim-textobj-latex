scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

function! s:get_val(key, val)
  return get(g:, 'textobj#latex#' . a:key, a:val)
endfunction

function! s:log(str)
  if s:get_val('debug', 0)
    call vimconsole#log(a:str)
  endif
endfunction

function! s:topos(pos, base)
  return [a:base[0], a:pos[0], a:pos[1], a:base[3]]
endfunction

function! s:escape(pattern) " {{{
    return escape(a:pattern, '\/~ .*^[''$')
endfunction " }}}

" \begin{tako} \begin{hoge} foo \end{hoge} \end{tako}
" \begin{hoge}
" foo
" \end{hoge}
function! s:select(in, b_pat, e_pat, conv)
  call s:log("pat=" . string([a:b_pat, a:e_pat]))
  let pos = getpos('.')
  call s:log("pos=" . string(pos))

  let s = search(a:b_pat, 'bcW')
  call s:log("s=" . s)
  if s == 0
    return 0
  endif

  let spos = getpos('.')
  call s:log("spos=" . string(spos))

  let sn = matchlist(getline("."), a:b_pat, spos[2] - 1)
  call s:log("sn=" . string(sn))
  if a:in
    let spos[2] += len(sn[0])

    call s:log("spos2=" . string(spos))
    call s:log("spos2=" . len(getline(spos[1])))
    if spos[2] > len(getline(spos[1]))
      let spos[1] += 1
      let spos[2] = 1
    endif
  endif

  if a:conv
    let epat = substitute(a:e_pat, '\\1', '\=s:escape(sn[1])', '')
  else
    let epat = a:e_pat
  endif
  call s:log("epat=" . string(epat))
  let epos = searchpairpos(a:b_pat, '', epat, 'W')
  call s:log("epos=" . string(epos))
  if epos[0] == 0 && epos[1] == 0 || epos[0] < pos[1]
    return 0
  endif

  let en = matchstr(getline("."), epat, epos[1] - 1)
  call s:log("en=" . en)
  if epos[0] == pos[1] && epos[1] + len(en) < pos[2]
    return 0
  endif
  if a:in
    if epos[1] > 1
      let epos[1] -= 1
    else
      let epos[0] -= 1
      let epos[1] = len(getline(epos[0]))
    endif
  else
    let epos[1] += len(en) - 1
  endif

  call s:log(['v', spos, s:topos(epos, pos)])
  return ['v', spos, s:topos(epos, pos)]

endfunction


let s:ENV_BEGIN = '\s*\\begin\s*{\s*\(\k\+\*\=\)\s*}\s*\n\='
let s:ENV_END   = '\s*\\end\s*{\s*\1\s*}'

let s:DOLL_BEGIN = '\(\$\$\=\)'
let s:DOLL_END   = '\1'

let s:CMD_BEGIN = '\%(^\s*\)\\\k\+{'
let s:CMD_END   = '}'

function! textobj#latex#env_a()
  return s:select(0, s:ENV_BEGIN, s:ENV_END, 1)
endfunction

function! textobj#latex#env_i()
  return s:select(1, s:ENV_BEGIN, s:ENV_END, 1)
endfunction

function! textobj#latex#cmd_a()
  return s:select(0, s:CMD_BEGIN, s:CMD_END, 0)
endfunction

function! textobj#latex#cmd_i()
  return s:select(1, s:CMD_BEGIN, s:CMD_END, 0)
endfunction

function! textobj#latex#doll_a()
  return s:select(0, s:DOLL_BEGIN, s:DOLL_END, 1)
endfunction

function! textobj#latex#doll_i()
  return s:select(1, s:DOLL_BEGIN, s:DOLL_END, 1)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et ts=2 sts=2 sw=2 tw=0 fdm=marker:
