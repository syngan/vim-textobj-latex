filetype plugin on
set rtp+=~/.vim/bundle/vim-textobj-multitextobj
set rtp+=/tmp/vim-textobj-multitextobj
runtime! plugin/textobj/*.vim

scriptencoding utf-8

function! s:paste_code()
  read t/fixtures/multitextobj.tex
endfunction

let g:textobj_multitextobj_textobjects_a = [
\ [ "\<Plug>(textobj-latex-environment-a)",
\   "\<Plug>(textobj-latex-display-math-a)",
\   "\<Plug>(textobj-latex-inline-math-a)",
\   "\<Plug>(textobj-latex-command-a)",
\   "\<Plug>(textobj-latex-dollar-math-a)",
\   ],
\ ]

let g:textobj_multitextobj_textobjects_i = [
\ [ "\<Plug>(textobj-latex-environment-i)",
\   "\<Plug>(textobj-latex-display-math-i)",
\   "\<Plug>(textobj-latex-inline-math-i)",
\   "\<Plug>(textobj-latex-command-i)",
\   "\<Plug>(textobj-latex-dollar-math-i)",
\   ],
\ ]

describe 'multitextobj'
  before
    new
    set filetype=tex
    call s:paste_code()
  end

  after
    close!
  end

  it 'figure*'
    for row in [1,2,23,24]
      for col in range(1, len(getline(row)))
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-multitextobj-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [24, 13]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [1, 1]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-multitextobj-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [23, 1]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [2, 1]
      endfor
    endfor
    for row in [22]
      for col in [25]
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-multitextobj-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [24, 13]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [1, 1]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-multitextobj-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [23, 1]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [2, 1]
      endfor
    endfor
  end
  
  it 'screen'
    for row in [3,13,14,15,20]
      for col in range(1, len(getline(row)))
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-multitextobj-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [20, 12]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [3, 1]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-multitextobj-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [19, 14]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [4, 1]
      endfor
    endfor

    for row in [19]
      for col in range(1, 8) + [14]
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-multitextobj-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [20, 12]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [3, 1]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-multitextobj-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [19, 14]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [4, 1]
      endfor
    endfor

  end
  
  it 'equation*'
    for row in [4,6,11,12]
      for col in range(1, len(getline(row)))
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-multitextobj-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [12, 15]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [4, 1]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-multitextobj-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [11, 8]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [5, 1]
      endfor
    endfor
  end

  it 'label'
    for row in [5]
      for col in range(1, len(getline(row)))
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-multitextobj-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [5, 11]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [5, 1]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-multitextobj-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [5, 10]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [5, 8]
      endfor
    endfor
  end

  it 'array*'
    for row in [7,8,9,10]
      for col in range(1, len(getline(row)))
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-multitextobj-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [10, 11]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [7, 1]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-multitextobj-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [9, 8]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [8, 1]
      endfor
    endfor
  end

  it '\[ \]'
    for row in [16,17,18]
      for col in range(1, len(getline(row)))
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-multitextobj-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [18, 2]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [16, 1]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-multitextobj-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [17, 12]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [17, 1]
      endfor
    endfor
  end


  " skip line 19

  it '\vspace'
    for row in [21]
      for col in range(1, len(getline(row)))
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-multitextobj-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [row, len(getline(row))]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [row, 1]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-multitextobj-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [row, len(getline(row))-1]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [row, 9]
      endfor
    endfor
  end


  it '\caption, \label'
    for row in [22]
      for col in range(1, 24)
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-multitextobj-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [row, 24]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [row, 1]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-multitextobj-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [row, 23]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [row, 10]
      endfor

      let l = len(getline(row))
      for col in range(26, l)
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-multitextobj-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [row, l]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [row, 26]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-multitextobj-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [row, l-1]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [row, 33]
      endfor
    endfor
  end
end

" vim:set et ts=2 sts=2 sw=2 tw=0 fdm=marker:
