# uniformity.vim

*Safely make whitespace across your project consistent*

__uniformity.vim__ is a tool for batch updating whitespace across a project.
Because it's a batch tool intended to be run infrequently, it may be of use to
you [even if you don't normally use Vim](#why-vim).

By whitespace, I'm talking about changing indentation:

- 2-spaces to 4-spaces
- 4-spaces to 2-spaces
- Spaces to tabs
- Anything to anything really

But I'm also talking about:

- Stripping traililng whitespace
- Stripping zero-width Unicode characters
- [Changing line
  endings](http://vimdoc.sourceforge.net/htmldoc/options.html#'fileformat')
  (Windows → *nix, *nix → Windows, etc.)[*](#inconsistent-line-endings)
- [Changing the file
  encoding](http://vimdoc.sourceforge.net/htmldoc/options.html#'fileencoding')
- Adding or removing the [UTF
  BOM](https://en.wikipedia.org/wiki/Byte_order_mark)

### Is uniformity.vim right for you?

Depending on what you're trying to do, __there's a decent chance you don't even
need uniformity.vim__:

- Do you want to change what whitespace Vim uses for any new files you create?
  Take a look at the [built-in Vim
  settings](http://vim.wikia.com/wiki/Indenting_source_code)
- Do you want Vim to re-indent your files [based on what it thinks your code
  should look
  like](http://vimdoc.sourceforge.net/htmldoc/indent.html#C-indenting)?  Try
  [`gg=G`](http://vim.wikia.com/wiki/Fix_indentation).
- Do you want to change both leading and non-leading whitespace in the file?
  Try [this trick](http://stackoverflow.com/a/16892086/27581).

On the other hand...

Do you want to conservatively change whitespace so that only leading
indentation is changed (to minimize the risk of messing up formatting)?
__uniformity.vim__ might be the right tool for the job.

While batch updating indentation across a project, do you want to also strip
trailing whitespace, convert line endings, and convert all the files to a
single encoding?  __uniformity.vim__ might be the right tool for the job.

### Getting Started

#### Pre-requisites

__uniformity.vim__ requires that the
[__sleuth.vim__](https://github.com/tpope/vim-sleuth) plugin be installed.
This is necessary because __uniformity.vim__ relies on the
[`shiftwidth`](http://vimdoc.sourceforge.net/htmldoc/options.html#'shiftwidth')
setting of the buffer to reflect the current indentation of the file so it can
know how to change each line.

#### Installation

You'll want to use a plugin manager.  The instructions assume you're using
[__vim-plug__](https://github.com/junegunn/vim-plug).

Include the following lines in your
[`.vimrc`](http://vim.wikia.com/wiki/Open_vimrc_file):

```viml
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sleuth'
Plug 'mkropat/vim-uniformity'

call plug#end()
```

Restart Vim, then run `:PlugInstall` to complete the installation.

#### Configuration

Include the following lines in your
[`.vimrc`](http://vim.wikia.com/wiki/Open_vimrc_file):

```viml
let g:uniformity_indent = '    '
let g:uniformity_strip_trailing_whitespace = 1
let g:uniformity_strip_zerowidth_chars = 0
let g:uniformity_bomb = 0
let g:uniformity_fileencoding = 'utf-8'
let g:uniformity_fileformat = 'unix'
```

Change each setting as desired.  You may omit any setting to have it not take
effect.  After you're satisfied, load in the settings by restarting Vim or by
running [`:source
%`](http://vimdoc.sourceforge.net/htmldoc/repeat.html#:source).

Here's the full reference of what each option does:

Setting                                  | Description
-----------------------------------------|----------------------
`g:uniformity_indent`                    | The string that represents one level of desired indentation, such as a string that contains 2-spaces, 4-spaces, or a tab character. (To insert a tab character, you can use [this trick](http://stackoverflow.com/a/4781099/27581).)
`g:uniformity_strip_trailing_whitespace` | If set to `1`, [trailing whitespace](http://blog.codinghorror.com/whitespace-the-silent-killer/) will be stripped
`g:uniformity_strip_zerowidth_chars`     | If set to `1`, [zero-width Unicode characters](http://stackoverflow.com/a/11305926/27581) will be stripped
`g:uniformity_bomb`                      | What to set [`'bomb'`](http://vimdoc.sourceforge.net/htmldoc/options.html#'bomb') to
`g:uniformity_fileencoding`              | What to set [`'fileencoding'`](http://vimdoc.sourceforge.net/htmldoc/options.html#'fileencoding') to
`g:uniformity_fileformat`                | What to set [`'fileformat'`](http://vimdoc.sourceforge.net/htmldoc/options.html#'fileformat') to

#### Usage

To update the whitespace formatting in a single file, run:

    :Uniform

If the changes look good, save the file:

    :update

To update all the files in a project, we can use
[`:argdo`](http://vimdoc.sourceforge.net/htmldoc/editing.html#:argdo).  First
[`:lcd`](http://vimdoc.sourceforge.net/htmldoc/editing.html#:lcd) to the
project directory, then add all the files you're interested to the [*argument
list*](http://vimdoc.sourceforge.net/htmldoc/editing.html#argument-list) with
something like:

    :args **\*.c **\*.h

(Replace `*.c` and `*.h` with the extensions of the files that you are
interested in.)

To incrementally build up the *argument list*, check out
[`:argadd`](http://vimdoc.sourceforge.net/htmldoc/editing.html#:argadd).  To
exclude specific files or directories, check out
[`:argdelete`](http://vimdoc.sourceforge.net/htmldoc/editing.html#:argdelete).
You can view the contents of the *argument list* at any time by running
[`:args`](http://vimdoc.sourceforge.net/htmldoc/editing.html#:args).

Once you are satisifed that the *argument list* contains all the files you want
to act on, run:

    :argdo Uniform
    :argdo update

These commands will run through every file in the *argument list*, update the
whitespace in every file, then save all the files.

__Tip__: if you have a lot of files and you don't want to be prompted after
every screenful of results, try [`:set
nomore`](http://vimdoc.sourceforge.net/htmldoc/options.html#'more')

If you find `:argdo` cumbersome, you could also try
[`:bufdo`](http://vimdoc.sourceforge.net/htmldoc/windows.html#:bufdo),
[`:tabdo`](http://vimdoc.sourceforge.net/htmldoc/tabpage.html#:tabdo) or
[`:windo`](http://vimdoc.sourceforge.net/htmldoc/windows.html#:windo).  Or
better yet, write a plugin that does it better and I will gladly update this
README to point to it.

### Notes

#### Why Vim?

When writing a tool for batch processing a bunch of files, I typically don't
reach for a graphical/visual app like Vim as my first choice.  However, Vim
offers so much needed functionality out-of-the-box, [I can't imagine a simpler
way to get the same
functionality](https://github.com/mkropat/vim-uniformity/blob/master/autoload/uniformity.vim):

- Vim has tried-and-true support for loading in files in any number of combinations of line endings and file encodings
- Vim has a workable, albeit clunky, means for working with all the files in a project (`:argdo`, etc.)
- With [__sleuth.vim__](https://github.com/tpope/vim-sleuth), Vim has a tested library for auto-detecting the indentation settings of a file
- Vim works cross-platform

#### Inconsistent line endings

__uniformity.vim__ does not currently handle line-endings that are inconsistent
*within a single file* any better than Vim does out of the box.  If there were
interest in such functionality, I could see about building it in.
