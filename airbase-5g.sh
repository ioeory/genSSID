#!/bin/bash
maclist=$1
essid=0
spoof(){
	for mac in $(grep -E ^[^#] $maclist)
	do
		clear 
		sleep 1
		let essid=essid+111 
		airbase-ng -e $essid -c 36 -a "$mac" wlan0 & 
		echo "Starting sssid $essid ..."
	done
}

pkill airbase-ng
ifconfig  -a |grep wlan0 
if [ $? != 0 ];then
	echo "Device not found"
	exit
else
	if [ "$1" = "" ];then
		echo "no input file"
		exit 
	elif [ ! -e $1 ];then
		echo "no such file"
		exit
	
	fi

fi
	

#airbase-ng  -e 1111111111111 -c 40 -z 1 -w "1234567890" wlan0 &
#sleep 3
#ifconfig at0 192.168.2.1/24 up &
spoof


##this scrippt default interface is set to wlan0
