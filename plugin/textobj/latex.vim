if exists('g:loaded_textobj_latex_')
  finish
endif

call textobj#user#plugin('latex', {
\   'environment': {
\     '*select-a-function*': 'textobj#latex#env_a',
\     '*select-i-function*': 'textobj#latex#env_i',
\     'select-a': 'aLe',
\     'select-i': 'iLe',
\   },
\  'command' : {
\     '*select-a-function*': 'textobj#latex#cmd_a',
\     '*select-i-function*': 'textobj#latex#cmd_i',
\     'select-a': 'aLc',
\     'select-i': 'iLc',
\   },
\  'display-math': {
\     '*pattern*': ['\\\[', '\\\]'],
\     'select-a': 'aL[',
\     'select-i': 'iL[',
\   },
\  'dollar-math': {
\     '*select-a-function*': 'textobj#latex#doll_a',
\     '*select-i-function*': 'textobj#latex#doll_i',
\     'select-a': 'aL$',
\     'select-i': 'iL$',
\   },
\ })


let g:loaded_textobj_latex_ = 1

" vim:set et ts=2 sts=2 sw=2 tw=0 fdm=marker:
