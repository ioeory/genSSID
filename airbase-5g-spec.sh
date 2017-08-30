#!/bin/bash
maclist=$1
device=$2
essid=0
spoof(){
	for mac in $(grep  -E ^[^#] $maclist)
	do
		let essid=essid+111 
		airbase-ng -e $essid -c 36 -a "$mac"   $device & 
	done
}

if [ "$1" = "" ];then
	echo "no input file"
	exit 
elif [ ! -e $1 ];then
	echo "no such file"
	exit
elif [ ! -f $1 ];then
	echo "invalid file format"
	exit
fi

if [ "$2" = "" ];then
	echo "no device input"
	exit
else
	ifconfig  -a |grep $device 
	if [ $? != 0 ];then
		exit
	fi
fi


#airbase-ng  -e 1111111111111 -c 40 -z 1 -w "1234567890" $device &
#sleep 3
#ifconfig at0 192.168.2.1/24 up &
pkill airbase-ng
spoof



#[-W 1 (for wep)/ -W 1 -z 2 (for wpa)/ -W 1 -Z 2 (for wpa2)]
