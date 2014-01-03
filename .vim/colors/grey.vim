let g:colors_name="grey"

"Normal colours
hi Normal	guifg=#4c4c4c guibg=#bfbfbf

" highlight groups
hi Cursor	guibg=#999999 guifg=#262626
hi VertSplit	guibg=black guifg=black gui=none
hi Folded	guibg=grey30 guifg=grey75
hi FoldColumn	guibg=grey30 guifg=grey0
hi IncSearch	guifg=grey25 guibg=grey75
hi ModeMsg	guifg=grey25
hi MoreMsg	guifg=grey25
hi NonText	guifg=#4c4c4c guibg=#d8d8d8
hi Question	guifg=black
hi Search	guibg=black guifg=#d8d8d8	
hi SpecialKey	guifg=#262626 gui=bold
hi StatusLine	guibg=#262626 guifg=#d8d8d8 gui=none
hi StatusLineNC	guibg=#262626 guifg=#d8d8d8 gui=none
hi Title	guifg=grey0
hi Visual	gui=none guifg=grey40 guibg=grey90
hi WarningMsg	guifg=red gui=bold

" syntax highlighting groups
hi Comment	guifg=#8c8c8c ctermfg=darkgrey "gui=italic
hi Constant	guifg=#000000 ctermfg=darkgrey term=bold gui=bold
hi Identifier	guifg=#262626 term=bold "gui=bold
hi Statement	guifg=#4c4c4c gui=bold cterm=bold term=bold
hi PreProc	guifg=#000000
hi Type		guifg=#262626 term=bold cterm=NONE gui=bold
hi Special	guifg=#000000 cterm=bold term=bold
hi Operator guifg=#262626 cterm=bold cterm=NONE
hi Ignore	guifg=#ff0000 gui=bold
hi Todo		guifg=#4c4c4c guibg=#d8d8d8
hi Todo		guifg=#4c4c4c guibg=#d8d8d8

" Quan s'ofereix el menu de completar paroles
hi Pmenu		guifg=#000000 guibg=#727272
hi PmenuSel		guifg=#d8d8d8 guibg=#000000

" color terminal definitions
hi SpecialKey	ctermfg=black cterm=bold term=bold
hi NonText	guibg=grey15 cterm=bold ctermfg=black
hi Directory	ctermfg=darkgrey  guifg=#000000
hi ErrorMsg	cterm=bold ctermfg=7 ctermbg=1
hi IncSearch	cterm=NONE ctermfg=grey ctermbg=black
hi Search	cterm=NONE ctermfg=black ctermbg=darkgrey
hi MoreMsg	ctermfg=black
hi ModeMsg	cterm=NONE ctermfg=black
hi LineNr 	guifg=grey0 ctermfg=3 gui=bold
hi Question	ctermfg=black
hi StatusLine	cterm=bold,reverse
hi StatusLineNC cterm=reverse
hi VertSplit	cterm=reverse
hi Title	ctermfg=5
hi Visual	cterm=reverse
hi VisualNOS	cterm=bold,underline
hi WarningMsg	ctermfg=1
hi WildMenu	ctermfg=0 ctermbg=3
hi Folded	ctermfg=darkgrey ctermbg=NONE
hi FoldColumn	ctermfg=darkgrey ctermbg=NONE
hi DiffAdd	ctermbg=4
hi DiffChange	ctermbg=5
hi DiffDelete	cterm=bold ctermfg=4 ctermbg=6
hi DiffText	cterm=bold ctermbg=1
hi Special	ctermfg=5
hi Identifier	ctermfg=6
hi Statement	ctermfg=3
hi PreProc	ctermfg=5
hi Type		ctermfg=2
hi Underlined	cterm=underline ctermfg=5
hi Ignore	cterm=bold ctermfg=7
hi Ignore	ctermfg=darkgrey
hi Error	cterm=bold ctermfg=7 ctermbg=1
