" vim: set ft=vim sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker:

" Environment
" {

    " Identify platform {
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return  (has('win16') || has('win32') || has('win64'))
        endfunction
    " }

    " Helper Functions {
        silent function! TrySource(fn)
            if filereadable(expand(a:fn))
                :exec ":source ".a:fn
                return 1
            endif
                return 0
        endfunction

        " 删除行尾空白
        function! StripTrailingWhitespace()
                " Preparation: save last search, and cursor position.
                let _s=@/
                let l = line(".")
                let c = col(".")
                " do the business:
                %s/\s\+$//e
                " clean up: restore previous search history, and cursor position
                let @/=_s
                call cursor(l, c)
        endfunction
        " 检测是否有该插件
        func! IsBundled(name)
            if !exists('g:bundles')
                return 0
            endif
            for l:bundle in g:bundles
                if l:bundle['name'] == a:name
                    return 1
                endif
            endfor
            return 0
        endfunc
    " }

    " Basics {
        set nocompatible        " Must be first line
        if !WINDOWS()
            set shell=/bin/sh
        endif
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if WINDOWS()
          set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
          let $TMP = expand('~/.vim/tmp')
          let $TEMP = expand('~/.vim/tmp')
        endif
    " }

" }

" Encoding Settings
" {

    "gvim内部编码
    set encoding=utf-8
    "当前编辑文件编码
    set fileencoding=utf-8
    "支持打开文件的编码
    set fileencodings=ucs-bom,utf-8,gbk,cp936,gb2312,bug5,euc-jp,euc-kr,latinl
    "解决console输出乱码
    language messages zh_CN.utf-8
    "解决菜单乱码
    " source $VIMRUNTIME/delmenu.vim
    " source $VIMRUNTIME/menu.vim
    "设置终端编码为gvim内部编码encoding
    let &termencoding=&encoding

    " 确保在终端模式下能正确编码
    " 因为在windows下只能是gbk
    if !has('gui_running') && WINDOWS()
        set encoding=gbk
        set fileencoding=gbk
        " set fileencodings=ucs-bom,utf-8,gbk,cp936,gb2312,bug5,euc-jp,euc-kr,latinl
        language messages zh_CN.gbk
        let &termencoding=&encoding
    end

" }

if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    " execute "set <xUp>=\e[1;*A"
    " execute "set <xDown>=\e[1;*B"
    " execute "set <xRight>=\e[1;*C"
    " execute "set <xLeft>=\e[1;*D"

    " 未设置 xterm key, 使用默认的 screen 时则使用以下配置
    map <Esc>[A <Up>
    map <Esc>[B <Down>
    map <Esc>[C <Right>
    map <Esc>[D <Left>
endif
