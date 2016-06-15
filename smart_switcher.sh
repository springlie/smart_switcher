#! /bin/sh
# usage: set proxy_server automatically

function do_clear ()
{
	command unalias unalias &>/dev/null
	unalias clear	&>/dev/null
	unalias source	&>/dev/null
	unalias echo	&>/dev/null
	unalias export	&>/dev/null
	unalias unset	&>/dev/null
	clear
}

function print_proxy_server ()
{
	if [ -z $CECHO_IS_IMPORTED ]
	then
		if [ -z "$http_proxy" ]
		then
			echo "*** the proxy_server is [no_proxy]"
		else
			echo "*** the proxy_server is [$http_proxy]"
		fi
	else
		if [ -z "$http_proxy" ]
		then
			cecho "*** the proxy_server is " -bg -hl "[no_proxy]" -d
		else
			cecho "*** the proxy_server is " -bb -hl "[$http_proxy]" -d
		fi
	fi
}

function set_proxy ()
{
	export http_proxy=$1
	export https_proxy=$1
	export ftp_proxy=$1
	export RSYNC_PROXY=$1
	export GIT_SSH=$2
	export GIT_PROXY_COMMAND=$3
	### git config --global http.proxy http://$2
	### git config --global core.gitproxy $3
}

function unset_proxy ()
{
	unset http_proxy
	unset https_proxy
	unset ftp_proxy
	unset RSYNC_PROXY
	unset GIT_SSH
	unset GIT_PROXY_COMMAND
	### git config --global --unset http.proxy
	### git config --global --unset core.gitproxy
}

function main ()
{
	# clear env
	do_clear

	# set LAN env
	local PROXY_SERVER_IP="172.17.18.84"	# your proxy ip
	local PROXY_SERVER_PORT="8080"		# your prxoy port
	local PROXY_GATE=${PROXY_SERVER_IP}:${PROXY_SERVER_PORT}

	# set path
	local CUR_DIR='/tmp/smartswitcher'

	# routine
	echo "***************smart proxy switcher****************"
	print_proxy_server

	# am I in LAN now ?
	ping -c1 -W1 $PROXY_SERVER_IP &> /dev/null
	if [ $? -eq 0 ]
	then
		# build tmp path
		if [ ! -e $CUR_DIR ]
		then
			mkdir $CUR_DIR
		fi

		# for ssh protocol proxy
		#local GIT_PROXY_SSH=$CUR_DIR"/proxy4ssh."$(id -u)
		local GIT_PROXY_SSH=$CUR_DIR"/proxy4ssh"
		if [ ! -e $GIT_PROXY_SSH ]
		then
			local PROXY_SSH_STR='connect -H '$PROXY_GATE' "$@"'
			echo $PROXY_SSH_STR > $GIT_PROXY_SSH
			chmod 700 $GIT_PROXY_SSH
		fi

		# for git protocol prxoy
		#local GIT_PROXY_WRAP=$CUR_DIR"/proxywrapper."$(id -u)
		local GIT_PROXY_WRAP=$CUR_DIR"/proxywrapper"
		if [ ! -e $GIT_PROXY_WRAP ]
		then
			local GIT_PROXY_STR='ssh -o ProxyCommand="'$GIT_PROXY_SSH' %h %p" "$@"'
			echo $GIT_PROXY_STR > $GIT_PROXY_WRAP
			chmod 700 $GIT_PROXY_WRAP
		fi

		# install
		if [ -z "$CECHO_IS_IMPORTED" ]
		then
			echo "*** setting proxy env..."
		else
			cecho "*** setting " -b -hl "proxy" -d " env..."
		fi
		set_proxy $PROXY_GATE $GIT_PROXY_WRAP $GIT_PROXY_SSH

    else

		# uninstall
		if [ -z "$CECHO_IS_IMPORTED" ]
		then
			echo "*** setting no-proxy env..."
		else
			cecho "*** setting " -b -hl "no-proxy" -d " env..."
		fi
		unset_proxy
	fi

	print_proxy_server
	echo "***************************************************"
}

main
unset -f do_clear
unset -f set_proxy
unset -f unset_proxy
unset -f print_proxy_server
unset -f main

