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
}


function hoststatus(){
	if [[ $HOST_FILE_STATUS'x' == 'x' ]]; then
		echo "Hosts status is ${Red}UNKNOWN${NC}"
	else
		echo "Hosts status is ${Blue}$HOST_FILE_STATUS${NC}"
	fi
}

# compare version code and decide which command to be used for reset dns cache
# based on the instructions provided by https://support.apple.com/en-cn/HT202516
function resetdns(){
	local SYSTEM_VERSION=`sw_vers -productVersion`
	local SYSTEM_NAME="UNKNOWN"
	if [[ `sw_vers -productName`'x' == 'x' ]];then
		echo "System is not Mac OS X"
	elif [[ `sw_vers -productName`'x' == 'Mac OS X' ]];then
		echo "System is Mac OS X"
		export SYSTEM_NAME=`sw_vers -productName`
	elif [[ -f /etc/issue ]]; then
		SYSTEM_NAME=`cat /etc/issue | grep CentOS`
		if [[ $SYSTEM_NAME'x' == 'x' ]];then 
			echo "System is not CentOS"
		else
			echo "System is CentOS"
			export SYSTEM_NAME=$SYSTEM_NAME
		fi
	else
		echo "System status is unknown"
	fi
	# divide code numbers and make a tree
	
	
	# OS X Yosemite and later
	# reset the DNS cache in OS X v10.10.4 or later
	# sudo killall -HUP mDNSResponder
	# reset the DNS cache in OS X v10.10 through v10.10.3
	# sudo discoveryutil mdnsflushcache
	#
	# OS X Mavericks, Mountain Lion, and Lion
	# reset the DNS cache in OS X v10.9.5 and earlier
	# sudo killall -HUP mDNSResponder
	#
	# Mac OS X Snow Leopard
	# reset the DNS cache in OS X v10.6 through v10.6.8
	# sudo dscacheutil -flushcache
}

unset HOST_SWITCH_SCRIPT_PATH
