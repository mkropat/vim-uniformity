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

    let do_indent    = exists('g:uniformity_indent') && strlen(g:uniformity_indent)
    let do_trailing  = exists('g:uniformity_strip_trailing_whitespace') && g:uniformity_strip_trailing_whitespace
    let do_zerowidth = exists('g:uniformity_strip_zerowidth_chars') && g:uniformity_strip_zerowidth_chars

    for lnum in range(1, line('$'))
        let line = getline(lnum)

        if do_indent
            let line = s:ReplaceLineIndent(line, &shiftwidth, g:uniformity_indent)
        endif

        if do_trailing
            let line = s:StripTrailingWhitespace(line)
        endif

        if do_zerowidth
            let line = s:StripZerowidthChars(line)
        endif

        call setline(lnum, line)
    endfor

    if do_indent
        call setbufvar('', '&shiftwidth', s:GetWhitespaceLength(g:uniformity_indent))
    endif
endfunction

function! s:ReplaceLineIndent(line, buf_indent_length, target_indent)
    let leading_length = s:GetWhitespaceLength(matchstr(a:line, '^\s*'))

    let depth = leading_length / a:buf_indent_length
    let remainder = leading_length % a:buf_indent_length

    let new_indent = repeat(a:target_indent, depth) . repeat(' ', remainder)

    return substitute(a:line, '^\s*', new_indent, '')
endfunction

function! s:StripTrailingWhitespace(line)
    return substitute(a:line, '\s*$', '', '')
endfunction

function! s:StripZerowidthChars(line)
    return substitute(a:line, '[​‌‍﻿]', '', 'g')
endfunction

function! s:GetWhitespaceLength(whitespace)
    return strlen(substitute(a:whitespace, '	', repeat(' ', &tabstop), 'g'))
endfunction
