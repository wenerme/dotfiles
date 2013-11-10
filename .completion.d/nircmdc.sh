_foo() 
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="monitor"

    if [[ ${cur} == -* ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" ${cur}) )
        return 0
    fi
}

complete -F _foo nircmdc

_nircmdc()
{
	local cur prev opts folder
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"
	folder="~$folder.desktop$ ~$folder.programs$"
	opts="cdrom speak changesysvolume setsysvolume mutesysvolume
	cmdshorcut monitor screensaver standby exitwin qboxcom multiremote 
	rasdial rashangup win shortcut killprocess urlshortcut setdisplay
	execmd service regedit regsetval setfiletime clipboard paramsfile gac
	emptybin dlg cmdwait loop savescreenshot waitprocess infobox qbox
	qboxtop script inisetval inidelval regsvr inishutdown abortshutdown
	lockws hibernate exec2 shexec setfilefoldertime clonefiletime
	emptybin setprimarydisplay setbrightness changebrightness
	closeprocess setprocesspriority setprocessaffinity memdump beep
	stdbeep setvolume setsysvolume2 changesysvolume2 setappvolume
	changeappvolume muteappvolume setdefaultsounddevice setsubunitvolumedb
	mutesubunitvolume showsounddevices wait shellrefresh sysrefresh
	setcursor setcursorwin movecursor dlgany returnval sendkeypress
	sendkey sendmouse convertimage comverimages savescreenshotfull
	savescreenshotwin shellcopy filldelete elevate elevatecmd runas
	trayballoon setconsolemode setconsolecolor consolewrite
	debugwrite mediaplay"

	case "${prev}" in
		cdrom)
			COMPREPLY=( $(compgen -W "close open" -- ${cur}))
			return 0
			;;
		# speak text ~$clipboard$ 
		speak)
			COMPREPLY=( $(compgen -W "text xml file" -- ${cur}))
			return 0
			;;
		text)
			COMPREPLY=( $(compgen -W "~$clipboard$" -- ${cur}))
			return 0
			;;
		# 静音设置 0开 1关  2切换
		mutesysvolume)
			COMPREPLY=( $(compgen -W "0 1 2" -- ${cur}))
			return 0
			;;
		# 添加路径匹配
		cmdshorcut)
			COMPREPLY=( $(compgen -W "${folder}" -- ${cur}))
			return 0
			;;
		# 关闭显示器
		monitor)
			COMPREPLY=( $(compgen -W "off on low" -- ${cur}))
			return 0
			;;
		# exitwin logoff reboot poweroff
		exitwin)
			COMPREPLY=( $(compgen -W "logoff reboot poweroff" -- ${cur}))
			return 0
			;;
		# exit poweroff force
		poweroff)
			COMPREPLY=( $(compgen -W "force" -- ${cur}))
			return 0
			;;
		# multiremote  copy
		multiremote)
			COMPREPLY=( $(compgen -W "copy" -- ${cur}))
			return 0
			;;
		# 设置窗口 win trans/min/close/hide/show/settopmost/-.+style
		# +exstyle/child
		# win center alltop
		# title/class
		win)
			COMPREPLY=( $(compgen -W "trans min close hide show settopmost -style +style
			+exstyle child center" -- ${cur}))
			return 0
			;;
		center)
			COMPREPLY=( $(compgen -W "alltop" -- ${cur}))
			return 0
			;;
		# service restart
		service)
			COMPREPLY=( $(compgen -W "restart start stop pause continue auto
			manual disable boot system" -- ${cur}))
			return 0
			;;
		# clipboard set/readfile/clear
		clipboard)
			COMPREPLY=( $(compgen -W "set readfile clear writefile addfile
			saveimage copyimage saveclp loadclp" -- ${cur}))
			return 0
			;;
		*)
		;;
	esac

	COMPREPLY=( $(compgen -W "${opts}" -- ${cur}))
}

complete -F _nircmdc nircmdc
complete -F _nircmdc nircmdc.exe

