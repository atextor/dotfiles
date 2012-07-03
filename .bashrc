# texray's ~/.bashrc
# Author: Andreas Textor <textor.andreas@googlemail.com>

# ANSI Colors
export NONE="\033[0m"
export BLACK="\033[0;30m"
export DARKGRAY="\033[1;30m"
export RED="\033[0;31m"
export LIGHTRED="\033[1;31m"
export GREEN="\033[0;32m"
export LIGHTGREEN="\033[1;32m"
export BROWN="\033[0;33m"
export YELLOW="\033[1;33m"
export BLUE="\033[0;34m"
export LIGHTBLUE="\033[1;34m"
export PURPLE="\033[0;35m"
export LIGHTPURPLE="\033[1;35m"
export CYAN="\033[0;36m"
export LIGHTCYAN="\033[1;36m"
export LIGHTGRAY="\033[0;37m"
export WHITE="\033[1;37m"
# Convenience versions with \[ \] escapes. These are needed
# When colors are used e.g. in prompt variables, so that
# bash computes the length correctly. When possible use these
# instead.
export C_NONE="\[\033[0m\]"
export C_BLACK="\[\033[0;30m\]"
export C_DARKGRAY="\[\033[1;30m\]"
export C_RED="\[\033[0;31m\]"
export C_LIGHTRED="\[\033[1;31m\]"
export C_GREEN="\[\033[0;32m\]"
export C_LIGHTGREEN="\[\033[1;32m\]"
export C_BROWN="\[\033[0;33m\]"
export C_YELLOW="\[\033[1;33m\]"
export C_BLUE="\[\033[0;34m\]"
export C_LIGHTBLUE="\[\033[1;34m\]"
export C_PURPLE="\[\033[0;35m\]"
export C_LIGHTPURPLE="\[\033[1;35m\]"
export C_CYAN="\[\033[0;36m\]"
export C_LIGHTCYAN="\[\033[1;36m\]"
export C_LIGHTGRAY="\[\033[0;37m\]"
export C_WHITE="\[\033[1;37m\]"

#---------------------------------------------------------------------
# Utility functions - other functions depend on them.
#---------------------------------------------------------------------

# Locales for messages. Use english UTF-8 if available.
function message_locale() {
	if ! which locale >/dev/null; then exit; fi
	if locale -a | grep en_US.utf8 >/dev/null; then
		echo "en_US.utf8"
	else
		echo "C"
	fi
}

# Locales for units. Use german UTF-8 if available,
# otherwise english UTF-8 if available.
function unit_locale() {
	if ! which locale >/dev/null; then exit; fi
	if locale -a | grep de_DE.utf8 >/dev/null; then
		echo "de_DE.utf8"
	elif locale -a | grep en_US.utf8 >/dev/null; then
		echo "en_US.utf8"
	else
		echo "C"
	fi
}

# Echoes one of: home laptop lab hsrm hpux sun, or nothing
function whereami() {
	system=$(uname)
	if [ $system = "HP-UX" ]; then echo "hpux"; exit; fi
	if [ $system = "SunOS" ]; then echo "sun"; exit; fi
	if [ $HOSTNAME = "tengu" ]; then echo "home"; exit; fi
	if [ $HOSTNAME = "mastodon" ]; then echo "laptop"; exit; fi
	if [ ${HOSTNAME:0:2} = "vs" ]; then echo "lab"; exit; fi 
	if [ ${HOSTNAME:0:2} = "lx" ] || [ $HOSTNAME = "fozzie" ] || [ $HOSTNAME = "gonzo" ]; then echo "hsrm"; fi
}

# Function to run upon exit of shell.
function _exit() {
	clear
	echo -e "${NONE}Logged out at `date`"
}

# Asks a y/n question. Usage: if ask "something"; then ... ; fi
function ask() {
	echo -n "$@" '[Y/n] ' ; read ans
	case "$ans" in
		n*|N*) return 1 ;;
		*) return 0 ;;
	esac
}


# Require can be used by other functions to make sure that certain commands exist
# before a whole process of things is started (which potentially leaves temp files and such)
function require() {
	which "$1" &>/dev/null
	if [ "x$?" = "x0" ]; then return 0; fi
	if [ "x$2" = "xquiet" ]; then return 1; fi
	if ask "Command not found: $1. Continue?"; then return 0; fi
	return 1
}

# This function (name compulsory) looks up a command when no alias or binary is found
# on the path. This wraps different lookup tools for Arch Linux and Ubuntu, and uses
# the best available tool.
function command_not_found_handle() {
	if [ -x /usr/bin/cnf-lookup ]; then
		# Arch Linux: command-not-found (from AUR)
		/usr/bin/cnf-lookup $1
		return $?
	elif [ -x /usr/bin/pkgfile ]; then
		# Arch Linux: pkgtools (from community repo)
		# There's also /usr/share/pkgtools/pkgfile-hook.bash which could be sourced,
		# but I like to have the logic in one place
		local pkgs="$(pkgfile -b -v -- "$1")"
		if [ ! -z "$pkgs" ]; then
			echo -e "\n$1 may be found in the following packages:\n$pkgs"
			return 0
		fi
	elif [ -x /usr/lib/command-not-found ]; then
		# Ubuntu's standard command-not-found handler
		/usr/bin/python /usr/lib/command-not-found -- $1
		return $?
	elif [ -x /usr/share/command-not-found ]; then
		# Ubuntu's standard command-not-found handler
		/usr/bin/python /usr/share/command-not-found -- $1
		return $?
	fi
	# Nothing :/
	printf "bash: $(gettext bash "%s: command not found")\n" $1 >&2
	return 127
}

#---------------------------------------------------------------------
# Prompt Functions
#---------------------------------------------------------------------

# Construct informative prompt for different version control systems (vcs).
# Code inspired by http://glandium.org/blog/?p=170, display inspired
# by http://briancarper.net/blog/570/git-info-in-your-zsh-prompt.
# My solution doesn't have the vcs_info limitation mentioned there though :)
# Currently supports git and svn (the only ones I use).
__prompt_vcs() {
	local sub_dir git_dir svn_dir
	vcs_status_indicator="◾"

	git_dir() {
		git rev-parse --show-cdup 2>&1 &>/dev/null || return 1
		ref=$(git symbolic-ref -q HEAD || git name-rev --name-only HEAD 2>/dev/null)
		ref=${ref#refs/heads/}
		vcs="git"

		staged=0; unstaged=0; untracked=0
		while IFS= read -r line; do
			case "${line:0:1}" in
				M|A|D|R) staged=1;;
				'?') untracked=1;;
			esac
			case "${line:1:1}" in 
				M|D) unstaged=1;;
			esac
		done <<< "$(git status --porcelain 2> /dev/null)"

		stat=
		[ $staged -eq 1 ] && stat+="$LIGHTGREEN$vcs_status_indicator$NONE"
		[ $unstaged -eq 1 ] && stat+="$YELLOW$vcs_status_indicator$NONE"
		[ $untracked -eq 1 ] && stat+="$LIGHTRED$vcs_status_indicator$NONE"
		return 0
	}

	# TODO somehow use "timeout(1)" to limit the run time of svn.
	# svn status sometimes takes several seconds, which can be incredibly annoying
	# if you are waiting for your prompt.
	svn_dir() {
		[ -d ".svn" ] || return 1
		which svn 2>&1 &>/dev/null || return 1
		base_dir="."
		while [ -d "$base_dir/../.svn" ]; do base_dir="$base_dir/.."; done
		base_dir=$(readlink -f "$base_dir")
		ref=$(svn info "$base_dir" | awk '/^URL/ { sub(".*/","",$0); r=$0 } /^Revision/ { sub("[^0-9]*","",$0); print r":"$0 }')
		vcs="svn"

		added=0; modified=0; untracked=0
		while IFS= read -r line; do
			case "${line:0:1}" in
				A) added=1;;
				M|D) modified=1;;
				'?') untracked=1;;
			esac
		done <<< "$(svn status 2> /dev/null)"

		stat=
		[ $added -eq 1 ] && stat+="$LIGHTGREEN$vcs_status_indicator$NONE"
		[ $modified -eq 1 ] && stat+="$YELLOW$vcs_status_indicator$NONE"
		[ $untracked -eq 1 ] && stat+="$LIGHTRED$vcs_status_indicator$NONE"
		return 0
	}
	
	git_dir || svn_dir || return
	echo -e "${NONE}[${WHITE}${vcs}${LIGHTBLUE}|${GREEN}${ref}${stat}${NONE}]"
}

# Function that constructs the prompt string
prompt() {
	if [ "`whoami`" = "root" ]; then
		user="$C_LIGHTRED\u"
	else
		user="$C_WHITE\u"
	fi
	host="${C_LIGHTBLUE}@${C_WHITE}\h"
	curdir="${C_NONE}[${C_YELLOW}\w${C_NONE}]"
	vcsinfo="${C_NONE}\$(__prompt_vcs)"

	echo "${user}${host}${curdir}${vcsinfo}${C_NONE}\\$ "
}

#---------------------------------------------------------------------
# Global Aliases
#---------------------------------------------------------------------

alias ls='COLUMNS=$COLUMNS ls -F --color=auto'
alias ll='ls -l'
alias l='ls -l'
alias la='ls -lA'          # show hidden
alias lh='ls -lh'          # human readable (size in MB etc.)
alias lsd='du -D *'
alias lsi='ls -lSr'        # ls and sort by filesize
alias lasi='ls -lASr'      # show hidden and sort by filesize
alias lx='ls -lXB'         # sort by extension
alias lk='ls -lSr'         # sort by size, biggest last
alias lc='ls -ltcr'        # sort by and show change time, most recent last
alias lu='ls -ltur'        # sort by and show access time, most recent last
alias lt='ls -ltr'         # sort by date, most recent last

alias ..='cd ..'
alias cd..='cd ..'

# Avoid mistakes
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# better versions of common tools
alias pcp='progress_cp' # function, see below
alias df='better_df' # function, see below
alias grep='egrep --color=always'
alias g='egrep --color=always'
alias gi='egrep -i --color=always'
require most quiet && {
	alias lo='most'
} || {
	alias lo='less'
}

# misc. convenience binds
alias startx='exec startx -- -nolisten tcp'
alias :q='exit'
alias :e='vim'
alias vi='vim'
alias filecount="ls -1|wc -l"
alias du='du -sh'
alias sra="screen -d -R pts-1.`hostname`"   # always (re-)attach "the" screen session
alias ip='curl http://showip.spamt.net/'
alias isb='rlwrap scala -deprecation -unchecked'
alias hd='mplayer -vc coreserve'
# CLI friendly pastebin :-)
# Usage: cat foo.txt | sprunge
alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"

alias scpresume='rsync --partial --progress -rsh=ssh'

alias dos2unix='perl -pi -e "s/\r//g"'
alias osx2unix='perl -pi -e "s/\r/\n/g"'
alias unix2dos='perl -pi -e "s/\n/\r\n/g"'
alias chomp="tr -d $'\n'"
alias acroread='acroread 2>/dev/null'

#---------------------------------------------------------------------
# Bash completion
#---------------------------------------------------------------------

# Only enable programmable bash completion for certain commands
complete -d cd
enable_completion_commands="git"
for cmd in $enable_completion_commands; do
	[ -f /etc/bash_completion.d/$cmd ] && source /etc/bash_completion.d/$cmd 
done

#---------------------------------------------------------------------
# Environment
#---------------------------------------------------------------------

# Locales. Only set if available. The functions (see above)
# determine if the locales are available and fall back to C if not.
# Messages in english please.
msg_loc=$(message_locale)
# Time, date, papersize etc. in german please.
unt_loc=$(unit_locale)
unset LC_ALL
export LANG=$msg_loc
export LANGUAGE=$msg_loc
export LC_CTYPE=$msg_loc
export LC_NUMERIC=$msg_loc
export LC_MESSAGES=$msg_loc
export LC_NAME=$msg_loc

export LC_COLLATE=$unt_loc
export LC_ADDRESS=$unt_loc
export LC_TELEPHONE=$unt_loc
export LC_MEASUREMENT=$unt_loc
export LC_IDENTIFICATION=$unt_loc
export LC_TIME=$unt_loc
export LC_MONETARY=$unt_loc
export LC_PAPER=$unt_loc

export PATH="/bin:/usr/bin:/sbin"

# PATH (append; default PATH is specified in /etc/profile)
[ -d /usr/local/bin ] && PATH="/usr/local/bin:$PATH"
[ ! `echo $PATH|grep acoc` ] && [ -e /usr/local/acoc/bin ] && PATH="/usr/local/acoc/bin:$PATH"
[ -d $HOME/bin ] && PATH="$HOME/bin:$PATH"
export PATH

# Manpath
[ -d /usr/share/man ] && export MANPATH=/usr/share/man:$MANPATH

# Prompt
export PS1=$(prompt) # see above function
export PS2=""$C_WHITE">"$C_NONE" "

# Bash Settings
export HISTFILE="$HOME/.bash_history"
export HISTCONTROL=ignoredups
export HISTFILESIZE=3000
export HISTTIMEFORMAT="%H:%M > "
export HISTIGNORE="&:bg:fg:ll:h"
unset MAILCHECK

# Editor ('vim' is the common default)
export EDITOR=/usr/bin/vim
export CVSEDITOR=$EDITOR
export VISUAL=$EDITOR
export XEDITOR=/usr/bin/gvim
export VIM=/usr/share/vim

# Pager ('less' is the common default)
export PAGER=/bin/less
export LESS=-R
export LESSCHARSET="utf-8"
require most quiet && {
	export MANPAGER=$(which most)
} || {
	export MANPAGER=$(which less)
}

# Misc settings and fixes for various programs
export ignoreeof=0
export OOO_FORCE_DESKTOP=gnome
export _JAVA_AWT_WM_NONREPARENTING=1
#export GDK_NATIVE_WINDOWS=1
export RI="--format ansi -T"
export SBT_OPTS=-Xmx512M
#[ "$TERM" = "screen.rxvt" ] && export TERM="screen"

# Misc convenience vars vars
export FH="textor@login1.cs.hs-rm.de"
export FH2="textor@login2.cs.hs-rm.de"

#---------------------------------------------------------------------
# Miscellaneous
#---------------------------------------------------------------------

umask 022           # default file permissions not to be set (octal)
#mesg y              # enable any messages users may send you with `write`
#ulimit -u 200000       # max. user processes
setterm -blength 0  # no beeps on console
setterm -blank 0    # don't blank console
set -o notify       # notify when bg job done
set -b              # report status if bg job terminated
#set bell-style visible   # goes to inputrc!
set nobeep
stty -ixon

# run function on logout
trap _exit EXIT

# '-s' sets option, '-u' unsets option, '-q' supresses output of option.
shopt -s cdable_vars    # Make 'cd $VARIABLE' possible
shopt -s cdspell        # Minor typo correction for directory arguments to 'cd'
shopt -s checkwinsize   # Check window size after each command, and update LINES and COLUMNS if necessary
shopt -s cmdhist        # Save multi-line cmds in same history entry
shopt -u dotglob        # Include dot files in the results of pathname expansion
shopt -u execfail       # Non-interactive shells won't exit if 'exec' fails
shopt -s expand_aliases # Aliases are expanded (see bash(1), 'ALIASES')
shopt -s extglob        # Extended pattern matching features (see bash(1), 'Pathname Expansion')
shopt -s histappend     # Append to HISTFILE when shell exits (else: overwrite)
shopt -s hostcomplete   # Enable hostname completion with words containing '@'
shopt -u huponexit      # Send SIGHUP to all jobs when an interactive login shell exits
shopt -s interactive_comments    # Make '# comment' possible on command line
shopt -u lithist                 # (cmdhist must be set) multi-line cmds are saved to history with embedded newlines (else: semicolon separators)
shopt -u no_empty_cmd_completion # (readline) completion on empty line lists cmds in PATH
shopt -u nocaseglob     # Ignore case in pathname expansion
shopt -s progcomp       # Enable programmable completion
shopt -s sourcepath     # 'source'/'.' uses PATH to find directory containing the file supplied as an argument
shopt -u xpg_echo       # 'echo' expands backslash-escape sequences by default
shopt -u mailwarn       # No messages about mails

# File colors
[ -e ~/.dir_colors ] && eval `dircolors -b ~/.dir_colors`

#---------------------------------------------------------------------
# Machine dependent settings
# different paths, proxy settings, display resolution etc.
#---------------------------------------------------------------------

case $(whereami) in
home)
	alias wget='wget -c --tries=235'
	alias rn='rename.pl'
	alias fixresolution='xrandr -s 1920x1080'

	export ECLIPSE_HOME=/opt/eclipse
	;;
laptop)
	alias wget='wget -c --tries=235'
	alias rn='rename.pl'
	alias fixresoluton='xrandr -s 1440x900'
	;;
lab)
	alias wget='wget -Y on' # to use the proxy
	alias rn='~/bin/rename.pl'
	alias fixresolution='xrandr -s 2560x1024 --output HDMI2 --right-of VGA1'
	# ka = keine ablenkung = no distractions = black out 2nd monitor
	alias ka='xlock -nolock -mode blank -geometry 1280x1024+1280+0 +grabmouse'
	alias off1='rdesktop -g 2560x980 -f -z -x 0x80 -u a_textor -d vs off1'
	alias off1s='rdesktop -g 1280x980 -f -z -x 0x80 -u a_textor -d vs off1'
	alias off2='rdesktop -g 1280x980 -f -z -x 0x80 -u a_textor -d vs off2'

	proxyHost="proxy.cs.hs-rm.de"
	proxyPort=8080
	socksHost=8080
	socksPort=1080
	noProxy="wwwprod.vs.cs.hs-rm.de,localhost,www-intern.cs.hs-rm.de"
	export http_proxy="http://${proxyHost}:${proxyPort}"
	export https_proxy="http://${proxyHost}:${proxyPort}"
	export ftp_proxy="http://${proxyHost}:${proxyPort}"
	export socks_proxy="http://${socksHost}:${socksPort}"
	export no_proxy="$noProxy"

	export JAVA_HOME=/opt/jdk/jdk1.7
	export ANT_HOME=/opt/java/ant
	javaNoProxy="$(echo $noProxy | tr , '|')"
	export ANT_OPTS="-Dhttp.proxyHost=${proxyHost} -Dhttp.proxyPort=${proxyPort} -Dhttps.proxyHost=${proxyHost} -Dhttps.proxyPort=${proxyPort} -Dftp.proxyHost=${proxyHost} -Dftp.proxyPort=${proxyPort}"

	export PEGASUS_ROOT=$HOME/thesis/pegasus
	export PEGASUS_HOME=$HOME/thesis/pegasus
	export PEGASUS_PLATFORM=LINUX_IX86_GNU

	export M2_HOME=/opt/java/maven-3.0.3
	export MAVEN_HOME=$M2_HOME
	export M2=$M2_HOME/bin

	export PATH=$JAVA_HOME/bin:$PATH
	export PATH=$M2:$PATH
	export PATH=$PATH:/opt/tools/AdobeReader/Adobe/Reader9/bin
	export PATH=$PATH:~/bin/scala/bin
	;;
hsrm)
	alias wget='wget -Y on'	# to use the proxy

	export http_proxy="http://proxy.cs.hs-rm.de:8080"
	export https_proxy="http://proxy.cs.hs-rm.de:8080"
	export ftp_proxy="http://proxy.cs.hs-rm.de:8080"
	export socks_proxy="http://socks.cs.hs-rm.de:1080"
	;;
hpux)
	export JAVA_HOME="/opt/java1.4"
	export PATH=$JAVA_HOME:$PATH

	# Terminal settings
	if [ ! $TERM = "screen" ]; then
		eval `tset -s -Q -m ':?hp' `
	fi
	stty erase "^H" kill "^U" intr "^C" eof "^D" susp "^Z" hupcl ixon ixoff tostop tabs

	# Set up shell environment:
	set noclobber
	set history=20
	;;
sun)
	# Path
	PATH=/usr/bin:/usr/ucb:/etc:.:$PATH
	export PATH

	# Terminal settings
	# istrip (-istrip) - Strip (do not strip)	input	characters to seven bits.
	stty -istrip
	# setenv TERM `tset -Q -`
	;;
esac

#---------------------------------------------------------------------
# Functions for general use
#---------------------------------------------------------------------

# VLC CLI control. You need to enable the HTTP interface in
# Tools->Preferences->(switch to "show settings: all")->Interface->
# Main interfaces->Tick "HTTP remote control interface". And obviously
# you need curl, too.
# TODO: Add function to list current song, list current playlist
# Use Xerces+Xalan and some XSLT to to that
function vlcc() {
	baseurl="http://localhost:8080/requests"
	case $1 in
	go)
		curl -g "$baseurl/status.xml?command=pl_play" &>/dev/null ;;
	play|pause)
		curl -g "$baseurl/status.xml?command=pl_pause" &>/dev/null ;;
	stop)
		curl -g "$baseurl/status.xml?command=pl_stop" &>/dev/null ;; 
	empty)
		curl -g "$baseurl/status.xml?command=pl_empty" &>/dev/null ;;
	add)
		curl -g "$baseurl/status.xml?command=in_enqueue&input=$2" &>/dev/null ;;
	addngo)
		curl -g "$baseurl/status.xml?command=in_play&input=$2" &>/dev/null ;;
	next)
		curl -g "$baseurl/status.xml?command=pl_next" &>/dev/null ;;
	prev)
		curl -g "$baseurl/status.xml?command=pl_previous" &>/dev/null ;;
	*)
		cat <<- EOF
		Usage: vlcc [go|play|pause|stop|empty|add <uri>|addngo <uri>|next|prev]
		vlcc go           - (reset song and) start playing
		vlcc play         - play/pause toggle
		vlcc pause        - play/pause toggle
		vlcc stop         - stop playing
		vlcc empty        - empty playlist
		vlcc add <uri>    - add URI to playlist
		vlcc addngo <uri> - add URI to playlist and start playing
		vlcc next         - next song in playlist
		vlcc prev         - previous song in playlist
		EOF
	;;
	esac
}

# Find file by pattern
function ff() {
	find . -type f -iname '*'$*'*' -ls ;
}

# Rot13 :)
function rot13() {
	cat "$@" | tr 'a-zA-Z' 'n-za-mN-ZA-M'
}

# Lowercases all files in current directory
function lcase() {
	IFS=$'\n';
	for i in `find $1 -maxdepth 1 -name '*[A-Z]*'`; do
		mv "$i" "`echo $i|tr [A-Z] [a-z]`"
	done
}

# Prints bash usage statistics
function recentlyused() {
	history | awk '{print $2}' | awk 'BEGIN {FS="|"} {print $1}' | sort | uniq -c | sort -rn | head -10
}

# Recodes a video for use with the Meizu M6 Miniplayer
# Command and description taken from http://www.taiabati.com/linux/video-for-meizu.html
function convertmeizu() {
	# The previous example outputs a video of 320x240, but we are assuming that the input file is in 4:3 scale (like PAL).
	# If the source video has a different aspect ratio (for example 16:9), we will need a letterboxing option. Let's imagine
	# we downloaded a video having a resolution of 448x256. If we scale down the width to 320 then we have a proportional
	# height of 176. So we need 64 extra pixel, meaning a black band of 32 pixels on the top and another at the bottom.
	# The command will become like this:
	#
	# mencoder Massive-Attack_karmacoma_1995.avi -oac mp3lame -lameopts cbr:mode=2:br=96 -af resample=44100 -srate 44100
	# -ofps 20 -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:cbp:trell:vbitrate=300 -vf scale=320:176 -vf-add expand=:240
	# -ffourcc XVID -o MA_karmacoma_95.avi -vf scale=320:176 -vf-add expand=:240
	# This means that the scaled video size will be 320x176 like said before, while the -vf-add option will add extra
	# black pixels over and under yuor frame in order to reach the 240 required height. Clever, eh? 

	# This assumes 4:3 video. TODO: Detect ratio and implement the above description for recode
	if [ $# -ne 1 ] || [ ! -e "$1" ]; then
		echo "Usage: convertmeizu file.video"
		return
	fi
	require mencoder && \
		mencoder "$1" -oac mp3lame -lameopts cbr:mode=2:br=96 -af resample=44100 \
			-srate 44100 -ofps 20 -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:cbp:trell:vbitrate=300 \
			-vf scale=320:240 -ffourcc XVID -o "${1%.*}-meizu.avi"
}

# CDable .zip/.jar archives using fuse-zip
# if 'cd foo.zip' is called, the archive is mounted to ~/.mounts/foo.zip-$MD5SUMOFFOO.ZIP and PS1 changed
# accordingly. If the directory is left, it is automatically unmounted and the mountpoint deleted.
# Currently does not take care of corner cases (e.g. cd'ing into the archive from multiple shells
# simultaneously).
function cd() {
	if [ "$1" = "-" ]; then
		builtin cd -
		return
	fi

	mountdir=$HOME/.mounts
	orghome=$(readlink -f $HOME)

	# We were previously in a ZIP path
	if [ -n "$INZIP" ]; then
		builtin cd "$@"
		if ! echo "$PWD" | grep "$INZIP" 2>&1 &>/dev/null; then
			# If we leave the directory, unmount zip file
			fusermount -u "$mountdir"/"$INZIP"
			rmdir "$mountdir"/"$INZIP"
			export PS1="$PS1ORG"
			if [ "$PWD" = "$mountdir" ]; then
				builtin cd "${INZIP_DIR/$orghome/$HOME}"
			else
				builtin cd "${PWD/$orghome/$HOME}"
			fi
			unset INZIP
			unset INZIP_FILE
			unset INZIP_DIR
		else
			# If we're still in the ZIP path, update PS1
			updated_path="${PWD/$mountdir\/$INZIP/$INZIP_FILE}"
			export PS1=${PS1ORG/\\w/${INZIP_DIR/$orghome/\~}/${C_LIGHTGREEN}${updated_path}}
		fi
	else
	# Were are in a normal directory
		if file -i "$1" | grep "application/zip" 2>&1 &>/dev/null; then
			if ! which fuse-zip 2>&1 &>/dev/null; then
				echo "Install fuse-zip to enable cd'able archives."
				builtin cd "$@"
				return
			fi

			[ ! -d "$mountdir" ] && mkdir "$mountdir"
			realpath=$(readlink -f "$1")
			filename=$(basename "$realpath")
			md5sum=$(echo $realpath | md5sum | cut -d' ' -f1)
			mountpoint="${mountdir}/${filename}-${md5sum}"

			mkdir -p "$mountpoint"
			fuse-zip "$1" "$mountpoint"
			originalpwd="$PWD"
			export INZIP="${filename}-${md5sum}"
			export INZIP_DIR=$(dirname "$realpath")
			export INZIP_FILE="$filename"
			export PS1ORG="$PS1"
			export PS1=${PS1ORG/\\w/${INZIP_DIR/$orghome/\~}/${C_LIGHTGREEN}${INZIP_FILE}}
			builtin cd "$mountpoint"
		else
			# normal directory
			builtin cd "$@"
		fi
	fi
}

# directory hardlink: pseudo-copies a directory structure
# recursively by cloning all the directories and hardlinking
# the files within
function dln() {
	case "$#" in
		1) arg1="$1"; arg2=".";;
		2) arg1="$1"; arg2="$2";;
		*) echo "Usage: dln dir [dir]"; return;;
	esac
	IFS=$'\n';
	pushd .
	[ ! ${arg1:0:1} = "/" ] && arg1="`pwd`"/"`basename \"$arg1\"`"
	[ ! ${arg2:0:1} = "/" ] && arg2="`pwd`"/"$2"
	mkdir -p "$arg2"; cd "${a%/*}" #cd "$arg1"
	find "`basename \"$arg1\"`" -type d -exec mkdir -p "$arg2"/"{}" \;
	find "`basename \"$arg1\"`" -type f -exec ln "${arg1%/*}"/"{}" "$arg2"/"{}" \;
	popd
}

# Recursively removes id3v1 and id3v2 tags from all mp3s in $1
# Usage: id3remove <directory>
function id3remove() {
	require id3v2 && {
		IFS=$'\n'
		for i in `find $1 -type f -iname '*.mp3'`; do
			id3v2 -D "$i"
		done
	}
}

# Frontend for playing varous file types
function mp() {
	ext="${1##*.}"
	lce=$(echo $ext | tr '[A-Z]' '[a-z]')

	case "$lce" in
		dm_68) require demoplay && demoplay "$1";;
		rm|ram) require realplay && realplay "$1";;
		mp3|ogg) require mplayer && mplayer -really-quiet "$1" ;;
		swf) require flashplayer && flashplayer "$1";;
		flv|asf|asx|avi|m2v|mov|mp4|mpeg|mpg|wmv|wma) require mplayer && mplayer -really-quiet $*;;
		pdf) require pdftohtml && require links && a="$(mktemp /tmp/$(basename $0).XXXXXX)"; pdftohtml "$1" -stdout > "$a" && links -force-html "$a" && rm "$a";;
		wav) require play && play "$1";;
		mod|s3m) require mikmod && mikmod "$1";;
		mid) require timidity && timidity "$1";;
		*) echo "Unknown File type: $ext"
	esac
}

# Frontend for extracting compressed files
function ep {
	ext="${1##*.}"
	lce=$(echo $ext | tr '[A-Z]' '[a-z]')

	case "$lce" in
		gz) [ ${1:$[${#1}-7]:7} = ".tar.gz" ] && tar xfvz "$1" || gunzip "$1";;
		tgz) tar xfvz "$1";;
		bz2) [ ${1:$[${#1}-8]:8} = ".tar.bz2" ] && tar xfvj "$1" || bunzip2 "$1";;
		tar) tar xfv "$1";;
		zip|pk3|jar) require unzip && a="${1%%.*}"; mkdir "$a"; mv "$1" "$a"; cd "$a"; unzip "$1"; mv "$1" ".."; cd "..";;
		rar) require unrar && a="${1%%.*}"; mkdir "$a"; mv "$1" "$a"; cd "$a"; unrar x "$1"; mv "$1" ".."; cd "..";;
		ace) require unace && a="${1%%.*}"; mkdir "$a"; mv "$1" "$a"; cd "$a"; unace x "$1"; mv "$1" ".."; cd "..";;
		7z) require 7za && a="${1%%.*}"; mkdir "$a"; mv "$1" "$a"; cd "$a"; 7za x "$1"; mv "$1" ".."; cd "..";;
		z|Z) require uncompress && uncompress "$1";;
		*) echo "Unknown File type: $ext"
	esac
}

# Get full name for a user name. Quickly check if LDAP works :-)
function nameof {
	getent passwd|grep $1|cut -d: -f5
}

# Compile and run source files
function run {
	ext="${1##*.}"

	case "$ext" in
	c|cc|cpp)
		[ "$ext" = "c" ] && i="gcc" || i="g++"
		echo -e "$i -Wall -pedantic -std=c99 -o \"${1%.*}\" \"$1\" && ./\"${1%.*}\""
		$i -Wall -pedantic -std=c99 -o "${1%.*}" "$1" && ./"${1%.*}"
		;;
	scala)
		require scalac && require scala && scalac "$1" && scala "${1%.*}"
		;;
	*) echo "run not defined for file type";;
	esac
}

# command line interface to leo online translator
function leo {
	if [ $# -ne 1 ]; then
		echo "Usage: leo <word>"
	else
		require curl && require html2text && {
			curl "http://dict.leo.org/ende?lp=ende&lang=en&searchLoc=0&cmpType=relaxed&sectHdr=on&spellToler=&search=$1" 2>/dev/null | 
			/bin/grep 'search results' | html2text -style pretty | sed -e 's/|//g' -e 's/\xBA/o/g' -e 's/.\x08//g' | tail -n +12 | head -n -40 
		}
	fi
}

# Display ANSI colours. Found this on the interwebs, credited
# to "HH".
function ansicolors() {
	esc="\033["
	echo -e "\t  40\t   41\t   42\t	43\t	  44	   45\t46\t 47"
	for fore in 30 31 32 33 34 35 36 37; do
		line1="$fore  "
		line2="	"
		for back in 40 41 42 43 44 45 46 47; do
			line1="${line1}${esc}${back};${fore}m Normal  ${esc}0m"
			line2="${line2}${esc}${back};${fore};1m Bold	${esc}0m"
		done
		echo -e "$line1\n$line2"
	done

	echo ""
	echo "# Example:"
	echo "#"
	echo "# Type a Blinkin TJEENARE in Swedens colours (Yellow on Blue)"
	echo "#"
	echo "#		   ESC"
	echo "#			|  CD"
	echo "#			|  | CD2"
	echo "#			|  | | FG"
	echo "#			|  | | |  BG + m"
	echo "#			|  | | |  |		 END-CD"
	echo "#			|  | | |  |			|"
	echo "# echo -e '\033[1;5;33;44mTJEENARE\033[0m'"
	echo "#"
	echo "# Sedika Signing off for now ;->"
}

# copy files and directories with a progress bar. requires pv to be installed.
# usage: progress_cp <source(s)> <target>  (sources can be files or directories)
# Note: still buggy for target directories that have spaces in them :(
function progress_cp() {
	require pv quiet && {
		if [ $# -lt 2 ]; then
			echo "Usage: cp <src> [<src> ...] <target>"
			return
		fi

		echo -en "Calculating size...\r"
		if [ $# -eq 2 -a -f "$1" -a ! -d "$2" ]; then
			size=$(du -sb "$1" | cut -f1)
			pv -s $size -p -t -e "$1" > "$2"
			return
		fi
		if [ $# -eq 2 -a -d "$1" -a ! -d "$2" ]; then
			files="$1/*"
			command="tar -cC \"$1\" . --transform 's|$1|$(basename "$1")|S'"
			target="$2"
		else
			command="tar -cspP"
			files=
			while [ $# -gt 1 ]; do
				if [ -r "$1" ]; then
					f=$(echo "$1"|sed 's#/$##g')
					command="$command \"$f\" --transform 's|$f|$(basename "$f")|S'"
					files="$files \"$f\""
				fi
				shift
			done
			target="$1"
		fi

		ducmd="du -sbc $files | tail -n 1 | cut -f1"
		size=$(eval $ducmd)

		mkdir -p "$target"
		pipe="$command | pv -s $size -p -e -t | tar -xPC "$target" "
		eval $pipe
	} || {
		/bin/cp $*
	}
}

# Use pydf as df replacement
function better_df() {
	require pydf quiet && {
		pydf|grep -v virtual|grep -v none|grep -v tmpfs|grep -v udev
	} || {
		/bin/df $*
	}
}

# Function for remote-controlling a running screen-session (virtually type in the buffers)
# Usage: screen_remote <stuff to type> <name of screen>
function screen_remote() {
	screen -X register 1 "$1"
	screen -p $2 -X paste 1
	screen -p $2 -X stuff $'\n'
}

