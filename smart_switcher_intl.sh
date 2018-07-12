#! /bin/sh
# internal functions

# clear the environment
do_clear ()
{
	command unalias unalias	&>/dev/null
	unalias clear			&>/dev/null
	unalias source			&>/dev/null
	unalias echo			&>/dev/null
	unalias export			&>/dev/null
	unalias unset			&>/dev/null
	clear
}

# print current situation
print_proxy_server ()
{
	local PROXY_STR=

	[ -n "$http_proxy" ] && PROXY_STR="[""$http_proxy""]" || PROXY_STR="[no_proxy]"
	[ -n "$CECHO_IS_IMPORTED" ] && cecho "*** the PROXY_GATEWAY is " -bg -hl "$PROXY_STR" || echo "*** the PROXY_GATEWAY is ""$PROXY_STR"
}

# read info from conf
get_info ()
{
	local SECTION=$1
	local ITEM=$2
	local VALUE=$(awk -F '=' '/\['$SECTION'\]/{a=1}a==1&&$1~/'$ITEM'/{print $2;exit}' "$SMART_SWITCHER_DIR"/gateway.ini)
	echo ${VALUE}
}

# read info from conf
check_valid_gateway ()
{
	local GATEWAY_NAME_ARRAY=
	local REAL_GATEWAY_NAME_ARRAY=
	local VALID_GATEWAY=
	local GATEWAY_HEADER=
	local GATEWAY_USER=
	local GATEWAY_PASSWORD=
	local GATEWAY_HOST=
	local GATEWAY_PORT=
	local GATEWAY=

	# read gateway name array
	GATEWAY_NAME_ARRAY=$(get_info ALL gateways)

	# traverse gateway array & try to find a valid gateway
	for GATEWAY_NAME in ${=GATEWAY_NAME_ARRAY[@]}
	do
		GATEWAY_HEADER=$(get_info "$GATEWAY_NAME" header)
		GATEWAY_USER=$(get_info "$GATEWAY_NAME" user)
		GATEWAY_PASSWORD=$(get_info "$GATEWAY_NAME" password)
		GATEWAY_HOST=$(get_info "$GATEWAY_NAME" host)
		GATEWAY_PORT=$(get_info "$GATEWAY_NAME" port)

		GATEWAY="${GATEWAY_HEADER}"
		
		[ -n "${GATEWAY_USER}" ] && [ -n "${GATEWAY_PASSWORD}" ] && GATEWAY="${GATEWAY}""${GATEWAY_USER}"":""${GATEWAY_PASSWORD}""@"

		GATEWAY="${GATEWAY}""${GATEWAY_HOST}"":""${GATEWAY_PORT}"

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

	echo "$VALID_GATEWAY"
}

# install specified proxy conf
install_proxy ()
{
	local GATEWAY=$1
	local GATEWAY_PATH=
	local GIT_PROXY_SSH=
	local PROXY_SSH_STR=
	local GIT_PROXY_WRAP=

	GATEWAY_PATH="$(echo $GATEWAY | tr -s "/" "_")"

	# build tmp path
	local CACHE_DIR='/tmp/smartswitcher'
	if [ ! -e "$CACHE_DIR" ]
	then
		mkdir "$CACHE_DIR"
		chmod 755 "$CACHE_DIR"
	fi

	# for ssh protocol proxy
	GIT_PROXY_SSH="$CACHE_DIR""/proxy4ssh."$(id -F)."$GATEWAY_PATH"
	if [ ! -e "$GIT_PROXY_SSH" ]
	then
		PROXY_SSH_STR='connect -H '$GATEWAY' "$@"'
		echo "$PROXY_SSH_STR" > "$GIT_PROXY_SSH"
		chmod 700 "$GIT_PROXY_SSH"
	fi

	# for git protocol prxoy
	GIT_PROXY_WRAP="$CACHE_DIR""/proxywrapper."$(id -F)."$GATEWAY_PATH"
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
}

# uninstall prox
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
}

