#! /bin/sh
# usage: set proxy_server automatically, if you set your proxy info in gateway.ini

################################ setup run only at the beginning of script loaded

setup ()
{
	# source intl file
	source "${SMART_SWITCHER_DIR}"/smart_switcher_intl.sh

	# clear env
	do_clear

	# routine begin
	echo "***************smart proxy switcher****************"
	print_proxy_server

	# check valid gateway
	local GATEWAY=
	GATEWAY=$(check_valid_gateway)

	# work
	[ -n "$GATEWAY" ] && install_proxy "$GATEWAY" || uninstall_proxy

	# routine end
	print_proxy_server
	echo "***************************************************"
}

setup
unset -f do_clear
unset -f print_proxy_server
unset -f get_info
unset -f check_valid_gateway
unset -f install_proxy
unset -f uninstall_proxy
unset -f setup

################################################# sm_trigger will run anytime
sm_toggle ()
{
	# source intl file
	source "${SMART_SWITCHER_DIR}"/smart_switcher_intl.sh

	# clear env
	do_clear

	# routine begin
	echo "***************smart proxy switcher****************"
	print_proxy_server

	# check valid gateway
	local GATEWAY=
	GATEWAY=$(check_valid_gateway)

	# work
	[ -n "$http_proxy" ] && uninstall_proxy || 
		{ [ -n "$GATEWAY" ] && install_proxy "$GATEWAY" || uninstall_proxy }

	# routine end
	print_proxy_server
	echo "***************************************************"

	unset -f do_clear
	unset -f print_proxy_server
	unset -f get_info
	unset -f check_valid_gateway
	unset -f install_proxy
	unset -f uninstall_proxy
}

