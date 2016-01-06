function! uniformity#Uniform() abort
    if exists('g:uniformity_bomb')
        call setbufvar('', '&bomb', g:uniformity_bomb)
    endif

    if exists('g:uniformity_fileencoding')
        call setbufvar('', '&fileencoding', g:uniformity_fileencoding)
    endif

    if exists('g:uniformity_fileformat')
        call setbufvar('', '&fileformat', g:uniformity_fileformat)
    endif

    if exists('g:uniformity_indent')
        call s:ReplaceBufIndent(g:uniformity_indent)
    endif

    call s:StripTrailingWhitespace()
endfunction

function! s:ReplaceBufIndent(indent)
    let buf_indent_length = &shiftwidth
    let target_length = s:GetWhitespaceLength(a:indent)

    if buf_indent_length == target_length
        return
    endif

    for lnum in range(1, line('$'))
        let line = getline(lnum)

        let line = s:ReplaceLineIndent(line, buf_indent_length, a:indent)

        call setline(lnum, line)
    endfor

    call setbufvar('', '&shiftwidth', target_length)
endfunction

function! s:ReplaceLineIndent(line, buf_indent_length, target_indent)
    let leading_length = s:GetWhitespaceLength(matchstr(a:line, '^\s*'))

    let depth = leading_length / a:buf_indent_length
    let remainder = leading_length % a:buf_indent_length

    let new_indent = repeat(a:target_indent, depth) . repeat(' ', remainder)

    return substitute(a:line, '^\s*', new_indent, '')
endfunction

function! s:StripTrailingWhitespace()
    for lnum in range(1, line('$'))
        let line = getline(lnum)
        let line = substitute(line, '\s*$', '', '')
        call setline(lnum, line)
    endfor
endfunction

function! s:GetWhitespaceLength(whitespace)
    return strlen(substitute(a:whitespace, '	', repeat(' ', &tabstop), 'g'))
endfunction
