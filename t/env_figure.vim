filetype plugin on
runtime! plugin/textobj/*.vim

scriptencoding utf-8

function! s:paste_code()
  read t/fixtures/figure.tex
endfunction

describe 'figure'
  before
    new
    set filetype=tex
    call s:paste_code()
  end

  after
    close!
  end

  it 'figure*'
    for row in [1,2,12,13,14,15]
      for col in range(1, len(getline(row)) - (row == 15 ? 5 : 0))
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-environment-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [15, 13]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [1, 1]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-environment-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [14, 36]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [2, 1]
      endfor
    endfor
  end
  
  it 'equation*'
    for row in [3,4,5,10,11]
      for col in range(1, len(getline(row)))
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-environment-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [11, 15]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [3, 1]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-environment-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [10, 8]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [4, 1]
      endfor
    endfor
  end

  it 'array'
    for row in [6,7,8,9]
      for col in range(1, len(getline(row)))
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-environment-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [9, 11]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [6, 1]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-environment-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [8, 8]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [7, 1]
      endfor
    endfor
  end

end

" vim:set et ts=2 sts=2 sw=2 tw=0 fdm=marker:
