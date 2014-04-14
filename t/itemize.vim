filetype plugin on
runtime! plugin/textobj/*.vim

scriptencoding utf-8

function! s:paste_code(lines)
  put =a:lines
  1 delete _
endfunction

describe 'itemize'
  before
    new
    set filetype=tex
  end

  after
    close!
  end

  it 'normal'
    call s:paste_code([
        \ 'latex',
        \ '\begin{itemize}',
        \ '\item hoge',
        \ '\item foo',
        \ '\end{itemize}',
        \ 'tako'])

    for row in range(2, 5)
      for col in range(1, len(getline(row)))
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-environment-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [5, 13]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [2, 1]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-environment-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [4, 9]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [3, 1]
      endfor
    endfor

    for row in [1, 6]
      for col in range(1, len(getline(row)))
        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-environment-a)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [row, col]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [row, col]

        call cursor([row, col])
        execute 'normal' "v\<Plug>(textobj-latex-environment-i)\<Esc>"
        execute 'normal!' "`>"
        Expect getpos('.')[1 : 2] == [row, col]
        execute 'normal!' "`<"
        Expect getpos('.')[1 : 2] == [row, col]

      endfor
    endfor
  end
end

" vim:set et ts=2 sts=2 sw=2 tw=0 fdm=marker:
