#!/bin/sh
HOST_SWITCH_SCRIPT_PATH=$( cd `dirname $0` && pwd)

HOST_FILE_PATH=$HOST_SWITCH_SCRIPT_PATH/hostfile
# prefix string of host files, configure this to change the file name arrange style, e.g hosts.dev, hosts.prod
HOST_FILE_PREFIX="hosts."
HOST_STATUS_FILE="$HOST_FILE_PATH/host_status"

if [[ -f $HOST_STATUS_FILE ]]; then
	source $HOST_STATUS_FILE
else
	if [[ ! -d $HOST_FILE_PATH ]]; then
		mkdir $HOST_FILE_PATH
	fi
	touch $HOST_STATUS_FILE
fi

function hostswitch(){
	if [[ ! -f ${HOST_FILE_PATH}/${HOST_FILE_PREFIX}${@} ]]; then
		echo "Error, template hosts file not exist."
	else
		sudo cp ${HOST_FILE_PATH}/${HOST_FILE_PREFIX}${@}	/etc/hosts
		HOST_FILE_STATUS=${HOST_FILE_PREFIX}${@}
		echo "Reset local DNS setting"
		sudo killall -HUP mDNSResponder
		# echo HOST_FILE_STATUS=${Blue}${HOST_FILE_PREFIX}${@}${NC}
		hoststatus
		echo "HOST_FILE_STATUS=$HOST_FILE_STATUS" > $HOST_STATUS_FILE
	fi
	resetdns
}


function hoststatus(){
	if [[ $HOST_FILE_STATUS'x' == 'x' ]]; then
		echo "${Red}Error hosts status UNKNOWN${NC}"
	else
		echo "hosts file in use: ${Blue}$HOST_FILE_STATUS${NC}"
	fi
}

unset HOST_SWITCH_SCRIPT_PATH
