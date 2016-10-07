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


" Use before config if available
call TrySource("~/.vim/.vimrc.before")


" Load keymaping
" 需要先设置 keymaping,这个会影响插件按键的绑定
call TrySource("~/.vim/.vimrc.keys")

" Load plugins
call TrySource("~/.vim/.vimrc.plugins")

" General
" {

    " set background=dark         " Assume a dark background
    " if !has('gui')
        "set term=$TERM          " Make arrow and other keys work
    " endif
    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8

    if has('clipboard')
        set clipboard=unnamed       " Always use * for copy-paste
    endif

    " Most prefer to automatically switch to the current file directory when
    " a new buffer is opened; to prevent this behavior, add the following to
    " your .vimrc.before.local file:
    "   let g:option_no_autochdir = 1
    if !exists('g:option_no_autochdir')
        " Always switch to the current file directory
        autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
    endif

    " set autowrite                     " Automatically write a file when leaving a modified buffer
    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    set spelllang=en               " Spell checking on, only for english
    set hidden                          " Allow buffer switching without saving

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    " Restore cursor to file position in previous editing session
    " To disable this, add the following to your .vimrc.before.local file:
    "   let g:option_no_restore_cursor = 1
    if !exists('g:option_no_restore_cursor')
        function! ResCur()
            if line("'\"") <= line("$")
                normal! g`"
                return 1
            endif
        endfunction

        augroup resCur
            autocmd!
            autocmd BufWinEnter * call ResCur()
        augroup END
    endif

    " Setting up the directories {
        set backup                  " Backups are nice ...
        if has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif

        " To disable views add the following to your .vimrc.before.local file:
        "   let g:spf13_no_views = 1
        if !exists('g:option_no_views')
            " Add exclusions to mkview and loadview
            " eg: *.*, svn-commit.tmp
            let g:skipview_files = [
                \ '\[example pattern\]'
                \ ]
        endif
    " }

" }

" Vim UI
" {

    if filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
        let g:solarized_termcolors=256
        let g:solarized_termtrans=1
        let g:solarized_contrast="normal"
        let g:solarized_visibility="normal"
        color solarized             " Load a colorscheme
    elseif filereadable(expand("~/.vim/colors/molokai.vim"))
        color molokai
        " 常常使用这个配色 但是注释颜色不明显
        hi Comment guifg=#ABCDEF
    endif


    " 当 IME 不可用的时候,使光标颜色更暗淡
    if exists('+iminsert')
        highlight link CursorIM Cursor
        highlight Cursor guibg=Gray guifg=NONE
    endif

    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode

    set cursorline                  " Highlight current line
    " 在终端下高亮列会看不清楚
    if has('gui_running')
        set cursorcolumn                " Highlight current column
    endif

    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode
    let g:CSApprox_hook_post = ['hi clear SignColumn']
    "highlight clear CursorLineNr    " Remove highlight color from current line number

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        " 0: 从不显示
        " 1: 需要时显示
        " 2: 总是显示
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        if exists('#fugitive')
            set statusline+=%{fugitive#statusline()} " Git Hotness
        endif
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set nu                          " Line numbers on
    if version >= 703
        set rnu                         " Use relativenumber
    endif
    set nuw=1                       " nu and rnu in same column
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set foldenable                  " Auto fold code
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

    " }

    " Formatting
    " {

    set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    set shellslash
    "set matchpairs+=<:>             " Match, to be used with %
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks

    " Remove trailing whitespaces and ^M chars
    " To disable the stripping of whitespace, add the following to your
    " .vimrc.before.local file:
    "   let g:option_keep_trailing_whitespace = 1
    autocmd FileType c,cpp,java,go,php,javascript,python,twig,xml,yml autocmd BufWritePre <buffer> if !exists('g:option_keep_trailing_whitespace') | call StripTrailingWhitespace() | endif
    autocmd FileType go autocmd BufWritePre <buffer> Fmt
    autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
    autocmd FileType haskell setlocal expandtab shiftwidth=2 softtabstop=2
    " preceding line best in a plugin but here for now.

    autocmd BufNewFile,BufRead *.coffee set filetype=coffee

    " Workaround vim-commentary for Haskell
    autocmd FileType haskell setlocal commentstring=--\ %s
    " Workaround broken colour highlighting in Haskell
    autocmd FileType haskell setlocal nospell

    " When save .vimrc, auto reload it
    " autocmd! BufWritePost *vimrc so $MYVIMRC
    " }

    " GUI Settings
    " {

    " GVIM- (here instead of .gvimrc)
    if has('gui_running')

        " a = 自动选择
        " A = 自动选择无模式的选择
        " c = 简单的选择使用控制台对话框而不是弹出式对话框
        " e = tab页标签
        " f = 前台
        " i = 使用Vim图标
        " m = 菜单栏
        " M = 不执行系统菜单脚本 $VIMRUNTIME/menu.vim。
        " g = 灰色菜单项
        " t = 菜包含可撕下的菜单项
        " T = 工具栏
        " r = 右侧滚动条
        " R = 如果有垂直分割的窗口，右边的滚动条总是存在
        " l = 右边的滚动条总是存在
        " L = 如果有垂直分割的窗口，左边的滚动条总是存在
        " b = 底部的（水平）滚动条总是存在
        " h = 限制水平滚动条的大小为光标所在行的长度
        " v = 对话框使用垂直的按钮布局
        set guioptions-=T
        set guioptions-=m

        " 窗口尺寸
        set lines=33
        set co=88

        " TODO 这个选项是没必要的
        if !exists("g:option_no_big_font")
            if LINUX() && has("gui_running")
                set guifont=Andale\ Mono\ Regular\ 16,Menlo\ Regular\ 15,Consolas\ Regular\ 16,Courier\ New\ Regular\ 18
            elseif OSX() && has("gui_running")
                set guifont=Andale\ Mono\ Regular:h16,Menlo\ Regular:h15,Consolas\ Regular:h16,Courier\ New\ Regular:h18
            elseif WINDOWS() && has("gui_running")
                set guifont=Andale_Mono_for_PowerLine:h10,Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
            endif
        endif
    else
        if &term == 'xterm' || &term == 'screen'
            set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
        endif
        "set term=builtin_ansi       " Make arrow and other keys work
    endif

    " }

    " Misc
    " {
    " Initialize directories
    " {
    " 因为在 clone repo 的时候已经有这些文件夹了,所以不需要手动创建
    set backupdir=~/.vim/tmp/backup//
    set dir=~/.vim/tmp/swap//
    set backup
    set writebackup

    if has('persistent_undo')
        set undodir=~/.vim/tmp/undo//
    endif
    " }

    "set iminsert=1
    "set imsearch=-1
    "inoremap <ESC> <ESC>:set iminsert=0<CR>
    "set noimd imi=0 ims=0

    if v:lang =~ 'zh'
        " 因为 listchars 里有双倍宽度字符,所以不能使用double值
        " set ambiwidth=double
        " 在中文环境下,拼写检查还不是那么好
        set nospell
    endif

    if exists('g:option_root_dir')
        let &path.=g:option_root_dir
    endif
    " }

    " Load local
    call TrySource("~/.vim/.vimrc.local")


if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"

    " tmux 未设置 xterm key, 使用默认的 screen 时则使用以下配置
    " map <Esc>[A <Up>
    " map <Esc>[B <Down>
    " map <Esc>[C <Right>
    " map <Esc>[D <Left>
    " Console movement
    " cmap <Esc>[A <Up>
    " cmap <Esc>[B <Down>
    " cmap <Esc>[C <Right>
    " cmap <Esc>[D <Left>
endif
