Books
=====

A simple script in fish shell to search through and open your book collection managed by calibre.
To use please source both script files at fish start up and install fzf the fuzzy file finder for your shell.

Usage

books [words in title]

books [title,author,tag,tags,series] [query]

If your result returns more than one possible match the result will be piped through fzf which will filter the remaining results as you type

![demo gif](https://github.com/michaelmrose/booksscript/blob/master/demo.gif "demo")
