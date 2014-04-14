filetype plugin on
runtime! plugin/textobj/*.vim

scriptencoding utf-8

function! s:paste_code(lines)
  put =a:lines
  1 delete _
endfunction

describe '\( inline mode \)'
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
        \ '\( x^2 + y^2 = R \)',
        \ 'foo \( x^2 + y^2 = R \) foo',
        \ 'tako'])

    for row in range(2, 2)
      for col in range(1, len(getline(row)))
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-inline-math-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [2, 19]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [2, 1]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-inline-math-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [2, 17]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [2, 3]
      endfor
    endfor


    for row in range(3, 3)
      let l = len(getline(row))
      for col in range(5, l - 4)
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-inline-math-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [3, 23]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [3, 5]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-inline-math-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [3, 21]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [3, 7]
      endfor
      for col in range(1, 4) + range(l - 3, l)
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-inline-math-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] + [1] == [row, col, 1]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] + [2] == [row, col, 2]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-inline-math-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] + [3] == [row, col, 3]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] + [4] == [row, col, 4]
      endfor

    endfor

    for row in [1, 4]
      for col in range(1, len(getline(row)))
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-inline-math-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [row, col]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [row, col]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-inline-math-i)\<Esc>"
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
        \ '\( x^2 + y^2',
        \ '= R \)',
        \ 'hoge \( x^2 + y^2',
        \ '= R \) foo',
        \ 'tako'])

    for row in range(2, 3)
      for col in range(1, len(getline(row)))
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-inline-math-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [3, 6]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [2, 1]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-inline-math-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [3, 4]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [2, 3]
      endfor
    endfor


    for row in range(4, 5)
      let l = len(getline(5))
      for col in (row == 4) ? 
      \ range(6, len(getline(4))) :
      \ range(1, l - 4)
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-inline-math-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [5, l - 4]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [4, 6]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-inline-math-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [5, l - 6]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [4, 8]
      endfor
    endfor

    for row in [1, 6]
      for col in range(1, len(getline(row)))
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-inline-math-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [row, col]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [row, col]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-inline-math-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [row, col]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [row, col]
      endfor
    endfor
  end
end

