Font for code
-------------

这里是一些常用字体,主要是常用于编程的.

如果你要使用 Powerline 字体,请先阅读 [About Powerline](#about-powerline)

字体列表

* [AndaleMono-Powerline](#andaleMono-powerline)
* [YaHei.Consolas](#yahei.consolas)

About Powerline
----------------------

Powerline中使用的编码

```viml
  " unicode symbols

  " RIGHT-POINTING DOUBLE ANGLE QUOTATIONMARK
  let g:airline_left_sep = '»'  " 0x00bb
  let g:airline_left_sep = '▶'  " 0x25b6 BLACK RIGHT-POINTING TRIANGLE
  " LEFT-POINTING DOUBLE ANGLE QUOTATIONMARK
  let g:airline_right_sep = '«' " 0x00ab
  let g:airline_right_sep = '◀' " 0x25c0 BLACK LEFT-POINTING TRIANGLE
  let g:airline_symbols.linenr = '␊'    " 0x240a SYMBOL FOR LINE FEED
  let g:airline_symbols.linenr = '␤'    " 0x2424 SYMBOL FOR NEWLINE
  let g:airline_symbols.linenr = '¶'    " 0x00b6 PILCROW SIGN
  let g:airline_symbols.branch = '⎇'    " 0x2387 ALTERNATIVE KEY SYMBOL
  let g:airline_symbols.paste = 'ρ'     " 0x03c1 GREEK SMALL LETTER RHO
  let g:airline_symbols.paste = 'Þ'     " 0x00de LATIN CAPITAL LETTER THORN
  let g:airline_symbols.paste = '∥'     " 0x2225 PARALLEL TO
  let g:airline_symbols.whitespace = 'Ξ'" 0x039e GREEK CAPITAL LETTER XI

  " powerline symbols
  " Unicode E000-F8FF is Private Use Area(PUA)
  let g:airline_left_sep = ''          " 0xe0b0
  let g:airline_left_alt_sep = ''      " 0xe0b1
  let g:airline_right_sep = ''         " 0xe0b2
  let g:airline_right_alt_sep = ''     " 0xe0b3
  let g:airline_symbols.branch = ''    " 0xe0a0
  let g:airline_symbols.readonly = ''  " 0xe0a2
  let g:airline_symbols.linenr = ''    " 0xe0a1

  " old vim-powerline symbols
  " These code in Unicode is not used currently
  " See http://www.unicode.org/charts/PDF/U2B00.pdf
  let g:airline_left_sep = '⮀'          " 0x2b80
  let g:airline_left_alt_sep = '⮁'      " 0x2b81
  let g:airline_right_sep = '⮂'         " 0x2b82
  let g:airline_right_alt_sep = '⮃'     " 0x2b83
  let g:airline_symbols.branch = '⭠'    " 0x2b60
  let g:airline_symbols.readonly = '⭤'  " 0x2b64
  let g:airline_symbols.linenr = '⭡'    " 0x2b61
```

|Powerline Symbols|Description|
|:------------------:|--------|
U+E0A0  |   Version control branch
U+E0A1  |   LN (line) symbol
U+E0A2  |   Closed padlock
U+E0B0  |   Rightwards black arrowhead
U+E0B1  |   Rightwards arrowhead
U+E0B2  |   Leftwards black arrowhead
U+E0B3  |   Leftwards arrowhead

* 关于在linux中使用这些Powerline字体的说明
    * [fontpatching](https://powerline.readthedocs.org/en/latest/fontpatching.html)
* 更多 Poweline 字体,参见
    * [Lokaltog/powerline-fonts](https://github.com/Lokaltog/powerline-fonts)

AndaleMono-Powerline
---------------------

是 [Andale Mono](http://en.wikipedia.org/wiki/Andale_Mono) 添加了 Powerline 的版本.

* 使用的 Old vim-powerline symbols.

YaHei.Consolas
---------------

混合了 雅黑 和 Consolas 的字体.
