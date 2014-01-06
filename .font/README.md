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
  let g:airline_left_sep = '»'  " 0x00bb
  let g:airline_left_sep = '▶'  " 0x25b6
  let g:airline_right_sep = '«' " 0x00ab
  let g:airline_right_sep = '◀' " 0x25c0
  let g:airline_symbols.linenr = '␊'    " 0x240a
  let g:airline_symbols.linenr = '␤'    " 0x2424
  let g:airline_symbols.linenr = '¶'    " 0x00b6
  let g:airline_symbols.branch = '⎇'    " 0x2387
  let g:airline_symbols.paste = 'ρ'     " 0x03c1
  let g:airline_symbols.paste = 'Þ'     " 0x00de
  let g:airline_symbols.paste = '∥'     " 0x2225
  let g:airline_symbols.whitespace = 'Ξ'" 0x039e

  " powerline symbols
  let g:airline_left_sep = ''          " 0xe0b0
  let g:airline_left_alt_sep = ''      " 0xe0b1
  let g:airline_right_sep = ''         " 0xe0b2
  let g:airline_right_alt_sep = ''     " 0xe0b3
  let g:airline_symbols.branch = ''    " 0xe0a0
  let g:airline_symbols.readonly = ''  " 0xe0a2
  let g:airline_symbols.linenr = ''    " 0xe0a1

  " old vim-powerline symbols
  let g:airline_left_sep = '⮀'          " 0x2b80
  let g:airline_left_alt_sep = '⮁'      " 0x2b81
  let g:airline_right_sep = '⮂'         " 0x2b82
  let g:airline_right_alt_sep = '⮃'     " 0x2b83
  let g:airline_symbols.branch = '⭠'    " 0x2b60
  let g:airline_symbols.readonly = '⭤'  " 0x2b64
  let g:airline_symbols.linenr = '⭡'    " 0x2b61
```


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
