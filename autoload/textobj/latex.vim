scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

function! s:get_val(key, val) " {{{
  return get(g:, 'textobj#latex#' . a:key, a:val)
endfunction " }}}

function! s:log(str) " {{{
  if s:get_val('debug', 0)
    call vimconsole#log(a:str)
  endif
endfunction " }}}

function! s:topos(pos, base) " {{{
  return [a:base[0], a:pos[0], a:pos[1], a:base[3]]
endfunction " }}}

function! s:escape(pattern) " {{{
    return escape(a:pattern, '\/~ .*^[''$')
endfunction " }}}

function! s:select_prev(in, s_pat, e_pat, key, mode) " {{{
  call s:log("pat=" . string([a:s_pat, a:e_pat, a:key]))
  let pos = getpos('.')
  call s:log("pos=" . string(pos))

  let spat = substitute(a:s_pat, '\\1', s:escape(a:key), '')
  let s = search(spat, 'bcW')
  call s:log("s=" . s . ',spat=' . spat)
  if s == 0
    return 0
  endif

  let spos = getpos('.')
  call s:log("spos=" . string(spos))

  let sn = matchlist(getline("."), spat, spos[2] - 1)
  call s:log("sn=" . string(sn))

  if has_key(a:mode, 'except')
    if sn[0] =~ a:mode.except
      return 0
    endif
  endif

  if a:in
    let spos[2] += len(sn[0])

    call s:log("spos2=" . string(spos))
    call s:log("spos2=" . len(getline(spos[1])))
    if spos[2] > len(getline(spos[1]))
      let spos[1] += 1
      let spos[2] = 1
    endif
  endif

  let epat = substitute(a:e_pat, '\\1', '\=s:escape(sn[1])', '')
  call s:log("epat=" . string(epat) . ',esearch=' . get(a:mode, 'esearch', -1))
  if get(a:mode, 'esearch', 0)
    let epos = searchpos(epat, 'W')
  else
    let spat = substitute(a:s_pat, '\\1', '\=s:escape(sn[1])', '')
    let epos = searchpairpos(spat, '', epat, 'W')
  endif
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

endfunction " }}}

function! s:select_next(in, s_pat, e_pat, key, mode) " {{{
  call s:log("pat=" . string([a:s_pat, a:e_pat, a:key]))
  let pos = getpos('.')
  call s:log("pos=" . string(pos))

  let epat = substitute(a:e_pat, '\\1', s:escape(a:key), '')

  let line = getline(".")
  if line =~# epat
    " search がうまく働かない.
    let t = 0
    while 1
      let t = match(line, epat, t)
      call s:log("t=" . t . ',epat=' . epat)
      if t < 0
        return 0
      endif

      let estr = matchstr(line, epat, t)
      call s:log("t=" . t . ',estr=' . estr . ",len=" . (t+len(estr)))
      if t < pos[2] && pos[2] <= t + len(estr)
        break
      endif
      let t += 1
    endwhile
    call setpos(".", s:topos([pos[1], t], pos))
  else
    let e = search(epat, 'cW')
    call s:log("e=" . e . ',epat=' . epat)
    if e == 0
      return 0
    endif
  endif
  let epos = getpos('.')
  call s:log("epos=" . string(epos))

  let en = matchlist(getline("."), epat, epos[2] - 1)

  call s:log("en=" . string(en))
  if !a:in
    let epos[2] += len(en[0]) - 1

    call s:log("epos2=" . string(epos))
    call s:log("epos2=" . len(getline(epos[1])))
  endif

  let spat = substitute(a:s_pat, '\\1', '\=s:escape(en[1])', '')
  call s:log("spat=" . string(spat) . ',esearch=' . get(a:mode, 'esearch', -1))
  if get(a:mode, 'esearch', 0)
    let spos = searchpos(spat, 'bW')
  else
    let epat = substitute(a:e_pat, '\\1', '\=s:escape(en[1])', '')
    let spos = searchpairpos(spat, '', epat, 'bW')
  endif
  call s:log("spos=" . string(spos))
  if epos[0] == 0 && epos[1] == 0
    \ || spos[0] > pos[1]
    \ || (spos[0] == pos[1] && spos[1] > pos[2])
    return 0
  endif

  let sn = matchstr(getline("."), spat, spos[1] - 1)
  call s:log("sn=" . sn)
  if a:in
    " 微調整
    let spos[1] += len(sn)
    if spos[1] >= getline(spos[0])
      let spos = [spos[0] + 1, 1]
    endif

    if epos[2] == 1
      let epos[1] -= 1
      let epos[2] = len(getline(epos[1]))
    endif
  endif

  call s:log(['v', s:topos(spos, pos), epos])
  return ['v', s:topos(spos, pos), epos]

endfunction " }}}

function! s:select(in, b_pat, e_pat, key, mode) " {{{
  let pos = getpos(".")
  try
    let p = s:select_prev(a:in, a:b_pat, a:e_pat, a:key, a:mode)
    if type(p) != type([]) && get(a:mode, 'do_next', 0)
      call setpos(".", pos)
      return s:select_next(a:in, a:b_pat, a:e_pat, a:key, a:mode)
    else
      return p
    endif
  endtry
endfunction " }}}

let s:ENV_KEY   = '\(\k\+\*\=\)'
let s:ENV_BEGIN = '\s*\\begin\s*{\s*\1\s*}\%({[^}]*}\|\[[^]]*\]\)*\s*\%(%.*\)\=\n\='
let s:ENV_END   = '\s*\\end\s*{\s*\1\s*}'

let s:DOLL_KEY   = '\(\$\{1,2}\)'
let s:DOLL_BEGIN = '\1'
let s:DOLL_END   = '\1'

" postexpr で対応すべきか. 微妙な実装
let s:CMD_BEGIN = '\%(^\s*\)\=\\\k\+{'
let s:CMD_END   = '}'
let s:CMD_EX   =  '\\\(begin\|end\)'

function! textobj#latex#env_a() " {{{
  return s:select(0, s:ENV_BEGIN, s:ENV_END, s:ENV_KEY,
        \ {'conv' : 1, 'do_next' : 1})
endfunction " }}}

function! textobj#latex#env_i() " {{{
  return s:select(1, s:ENV_BEGIN, s:ENV_END, s:ENV_KEY,
        \ {'conv' : 1, 'do_next' : 1})
endfunction " }}}

function! textobj#latex#cmd_a() " {{{
  return s:select(0, s:CMD_BEGIN, s:CMD_END, '', {'conv' : 0, 'except': s:CMD_EX})
endfunction " }}}

function! textobj#latex#cmd_i() " {{{
  return s:select(1, s:CMD_BEGIN, s:CMD_END, '', {'conv' : 0, 'except': s:CMD_EX})
endfunction " }}}

function! textobj#latex#doll_a() " {{{
  return s:select(0, s:DOLL_BEGIN, s:DOLL_END, s:DOLL_KEY,
        \ {'conv': 1, 'esearch': 1})
endfunction " }}}

function! textobj#latex#doll_i() " {{{
  return s:select(1, s:DOLL_BEGIN, s:DOLL_END, s:DOLL_KEY,
        \ {'conv': 1, 'esearch': 1})
endfunction " }}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et ts=2 sts=2 sw=2 tw=0 fdm=marker:
