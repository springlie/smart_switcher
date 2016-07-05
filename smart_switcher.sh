#! /bin/sh
# usage: set proxy_server automatically, if you set your proxy info in gateway.ini

do_clear ()
{
	command unalias unalias &>/dev/null
	unalias clear			&>/dev/null
	unalias source			&>/dev/null
	unalias echo			&>/dev/null
	unalias export			&>/dev/null
	unalias unset			&>/dev/null
	clear
}

print_proxy_server ()
{
	local PROXY_STR=

	[ -n "$http_proxy" ] && PROXY_STR="[""$http_proxy""]" || PROXY_STR="[no_proxy]"
	[ -n "$CECHO_IS_IMPORTED" ] && cecho "*** the PROXY_GATEWAY is " -bg -hl "$PROXY_STR" || echo "*** the PROXY_GATEWAY is ""$PROXY_STR"
}

get_info ()
{
	local SECTION=$1
	local ITEM=$2
	local VALUE=$(awk -F '=' '/\['$SECTION'\]/{a=1}a==1&&$1~/'$ITEM'/{print $2;exit}' "$SMART_SWITCHER_DIR"/gateway.ini)
	echo ${VALUE}
}

check_valid_gateway ()
{
	local GATEWAY_NAME_ARRAY=
	local VALID_GATEWAY=
	local GATEWAY_HOST=
	local GATEWAY_PORT=
	local GATEWAY=

	# read gateway name array
	GATEWAY_NAME_ARRAY=$(get_info ALL gateways)

	# traverse gateway array & try to find a valid gateway
	for GATEWAY_NAME in ${GATEWAY_NAME_ARRAY[@]}
	do
		GATEWAY_HOST=$(get_info "$GATEWAY_NAME" host)
		GATEWAY_PORT=$(get_info "$GATEWAY_NAME" port)
		GATEWAY="${GATEWAY_HOST}"":""${GATEWAY_PORT}"

		# am I in LAN now ?
		ping -c1 -W1 "$GATEWAY_HOST" &> /dev/null
		if [ $? -eq 0 ]
		then
			VALID_GATEWAY="$GATEWAY"
			break
		else
			continue
		fi
	done

	echo $VALID_GATEWAY >> /Users/springlie/sm.log

	echo "$VALID_GATEWAY"
}

install_proxy ()
{
	local GATEWAY=$1
	local GIT_PROXY_SSH=
	local PROXY_SSH_STR=
	local GIT_PROXY_WRAP=

	# build tmp path
	local CACHE_DIR='/tmp/smartswitcher'
	if [ ! -e "$CACHE_DIR" ]
	then
		mkdir "$CACHE_DIR"
		chmod 755 "$CACHE_DIR"
	fi

	# for ssh protocol proxy
	GIT_PROXY_SSH="$CACHE_DIR""/proxy4ssh."$(id -F)."$GATEWAY"
	if [ ! -e "$GIT_PROXY_SSH" ]
	then
		PROXY_SSH_STR='connect -H '$GATEWAY' "$@"'
		echo "$PROXY_SSH_STR" > "$GIT_PROXY_SSH"
		chmod 700 "$GIT_PROXY_SSH"
	fi

	# for git protocol prxoy
	GIT_PROXY_WRAP="$CACHE_DIR""/proxywrapper."$(id -F)."$GATEWAY"
	if [ ! -e "$GIT_PROXY_WRAP" ]
	then
		GIT_PROXY_STR='ssh -o ProxyCommand="'"$GIT_PROXY_SSH"' %h %p" "$@"'
		echo "$GIT_PROXY_STR" > "$GIT_PROXY_WRAP"
		chmod 700 "$GIT_PROXY_WRAP"
	fi

	# install
	[ -n "$CECHO_IS_IMPORTED" ] && cecho "*** setting " -b -hl "proxy" -d " env..." || echo "*** setting proxy env..."

	# set proxy
	export http_proxy=$GATEWAY
	export https_proxy=$GATEWAY
	export ftp_proxy=$GATEWAY
	export RSYNC_PROXY=$GATEWAY
	export GIT_SSH=$GIT_PROXY_WRAP
	export GIT_PROXY_COMMAND=$GIT_PROXY_SSH
	### git config --global http.proxy http://$2
	### git config --global core.gitproxy $3
}

uninstall_proxy ()
{
	
	# uninstall
	[ -n "$CECHO_IS_IMPORTED" ] && cecho "*** setting " -b -hl "no-proxy" -d " env..." || echo "*** setting no-proxy env..."

	unset http_proxy
	unset https_proxy
	unset ftp_proxy
	unset RSYNC_PROXY
	unset GIT_SSH
	unset GIT_PROXY_COMMAND
	### git config --global --unset http.proxy
	### git config --global --unset core.gitproxy
}

main ()
{
	# routine begin
	echo "***************smart proxy switcher****************"
	print_proxy_server

	# clear env
	do_clear

	# check valid gateway
	local GATEWAY=
	GATEWAY=$(check_valid_gateway)

	# work
	[ -n "$GATEWAY" ] && install_proxy "$GATEWAY" || uninstall_proxy

	# routing end
	print_proxy_server
	echo "***************************************************"
}

main
unset SMART_SWITCHER_DIR
unset -f do_clear
unset -f print_proxy_server
unset -f get_info
unset -f check_valid_gateway
unset -f install_proxy
unset -f uninstall_proxy
unset -f main

