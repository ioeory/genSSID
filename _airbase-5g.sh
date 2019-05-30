#!/bin/bash
maclist=$2
device=$1

SSIDB=(TP-Link DLink  Linksys OpenWrt PDCN Asus "Asus ROG" "Asus RT" TpLink  Tenda Net-core Aruba TotoLink Cisco NetGear XiaoMi Mercury \
Fast Phicomm Spark Z-Com Accton CoCom BLink JCG Buffalo Belkin ZTE HuaWei Trendnet Jetstream  Ubnt Zyxel Ruckus Alvarion Ubiquiti Serria Proxim\
Xirrus Meru Avaya  Cerio Ciena )
SLASHS=(- _ "" Home Office Outdoor)
#location=$(basename $2 |grep -oE ^.*[\.]?)
spoof(){
#	airbase-ng  -e 1111111111111 -c 40  -w "1234567890"  $device &

	for mac in $(grep  -E ^[^#] $maclist)
	do
		SLASH=${SLASHS[$RANDOM % ${#SLASHS[@]}]}
		SUBFIX=$(echo $mac|awk 'BEGIN{FS=":"} {print toupper($1$2$3$4)}')
		SSID=${SSIDB[$RANDOM % ${#SSIDB[@]}]}$SLASH$SUBFIX
		
		let i=i+1
		#let essid=essid+111 
		#essid=$(cat /dev/urandom | head -n 10 | md5sum | head -c 11) 
		sleep 1 
		clear
		airbase-ng -e $SSID -c 36 -w 1234567890 -a "$mac" $device & 
		echo "Starting $location-$i"
	        echo "SSID:-- $SSID "
		echo "MAC:--- $mac"
	done

}

if [ $UID -ne 0 ];then
	echo "This Script Must Run As Root..."
	exit
fi

if [ "$1" = "" ];then
	echo "no device input"
#	device="wlan0"
#	echo "try using $device.."
	exit
else
	ifconfig  -a |grep $device 
	if [ $? != 0 ];then
		echo "device not found.."
		exit
	fi
fi

if [ "$2" = "" ];then
	echo "no input file"
	exit 
elif [ ! -e $2 ];then
	echo "no such file"
	exit
elif [ ! -f $2 ];then
	echo "invalid file format"
	exit
fi

location=$(basename $2 |grep -oE ^.*[\.]?)
airmon-ng check kill
pkill airbase-ng

#airbase-ng  -e 1111111111111 -c 40  -w "1234567890" $device &
#sleep 3
#ifconfig at0 192.168.2.1/24 up &
spoof
sleep 1



#[-W 1 (for wep)/ -W 1 -z 2 (for wpa)/ -W 1 -Z 2 (for wpa2)]
