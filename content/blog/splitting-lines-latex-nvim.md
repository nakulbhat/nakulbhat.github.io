+++
date = '2025-10-17T22:09:30+05:30'
title = 'Splitting Lines in LaTeX Using Neovim'
author = 'Nakul Bhat'
summary = 'Dealing with LaTeX can be messy with paragraph-long lines, so I made a function to split and rejoin them.'
+++

LaTeX does not really care about how you format your source code. As an oft repeated example,
```latex
A sentence in LaTeX ends with a period.
A paragraph however, ends with an empty line, or a \par, which is the equivalent of an empty line.
```
This would render as a single paragraph (excusing the `\par` put in for
demonstration), disregarding the <kbd>CR</kbd> at the end of the first line.

Along similar lines, words in a LaTeX sense, are strings of
alphanumeric characters separated by whitespace. Additional whitespace between
two words is compressed, so these two sentences are equivalent.
```latex
This is a set      of   words.
This is a set of words.
```

This results in a complicated situation where lines of code edited in text wrap modes can inadvertently stretch hundreds of characters without being an issue.
When you move into a wrap-unfriendly editor like Neovim, this mess of a codebase becomes a nightmare rather quickly.
