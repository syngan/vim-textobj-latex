filetype plugin on
runtime! plugin/textobj/*.vim

scriptencoding utf-8

function! s:paste_code(lines)
  put =a:lines
  1 delete _
endfunction

describe 'doll'
  before
    new
    set filetype=tex
  end

  after
    close!
  end

  it '1line'
    call s:paste_code([
        \ 'latex',
        \ '$ x^2 + y^2 = R $',
        \ '$$ x^2 + y^2 = R $$',
        \ 'tako'])

    for row in range(2, 2)
      for col in range(1, len(getline(row)) - 1)
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-dollar-math-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [2, 17]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [2, 1]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-dollar-math-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [2, 16]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [2, 2]
      endfor
    endfor


    for row in range(3, 3)
      for col in range(1, len(getline(row)) - 2)
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-dollar-math-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [3, 19]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [3, 1]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-dollar-math-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [3, 17]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [3, 3]
      endfor
    endfor

    for row in [1, 4]
      for col in range(1, len(getline(row)))
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-dollar-math-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [row, col]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [row, col]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-dollar-math-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [row, col]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [row, col]
      endfor
    endfor
  end

  it '2line'
    call s:paste_code([
        \ 'latex',
        \ '$ x^2 + y^2',
        \ '= R $',
        \ '$$ x^2 + y^2',
        \ '= R $$',
        \ 'tako'])

    for row in range(2, 3)
      for col in range(1, len(getline(row)) - (row == 2 ? 0 : 1))
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-dollar-math-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [3, 5]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [2, 1]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-dollar-math-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [3, 4]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [2, 2]
      endfor
    endfor


    for row in range(4, 5)
      for col in range(1, len(getline(row)) - (row == 4 ? 0 : 2))
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-dollar-math-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [5, 6]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [4, 1]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-dollar-math-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [5, 4]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [4, 3]
      endfor
    endfor

    for row in [1, 6]
      for col in range(1, len(getline(row)))
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-dollar-math-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [row, col]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [row, col]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-dollar-math-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [row, col]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [row, col]
      endfor
    endfor
  end

end

" vim:set et ts=2 sts=2 sw=2 tw=0 fdm=marker:
