#!/bin/bash
maclist=$2
device=$1
SSIDB=(TP-Link DLink  Linksys OpenWrt PDCN Asus AsusROG AsusRT TpLink  Tenda Net-core Aruba TotoLink Cisco NetGear XiaoMi Mercury \
Fast Phicomm Spark Z-Com Accton CoCom BLink JCG Buffalo Belkin ZTE HuaWei Trendnet Jetstream  Ubnt Zyxel Ruckus Alvarion Ubiquiti Serria Proxim\
Xirrus Meru Avaya  Cerio Ciena )
SLASHS=(- _ "" Home Office  - _ - _ - _ - _ - _ - _ - _ "" "" "" )

spoof(){
#	airbase-ng  -e 1111111111111 -c 40  -w "1234567890"  $device &
	airmon-ng check kill
	pkill airbase-ng
	for mac in $(grep  -E ^[^#] $maclist)
	do
		SLASH=${SLASHS[$RANDOM % ${#SLASHS[@]}]}
		SUBFIX=$(echo $mac|awk 'BEGIN{FS=":"} {print toupper($1$2$3)}')
		SSID=${SSIDB[$RANDOM % ${#SSIDB[@]}]}$SLASH$SUBFIX
		
		let i=i+1
		#let essid=essid+111 
		#essid=$(cat /dev/urandom | head -n 10 | md5sum | head -c 11) 
		clear
		airbase-ng -e $SSID -c 36 -w 1234567890 -a "$mac" $device & 
		echo -e "\033[36mStarting $location-$i"
		echo -e "\033[32mSSID:-- $SSID \033[0m"
		echo -e "\033[33mMAC:--- $mac\033[0m"
		sleep 1 
	done
}

check_dev(){
	[[ $UID -ne 0 ]] && echo -e "\033[31m This script must run as root! \033[0m" && exit
	[[ $device = "" ]] && echo -e "\033[33mNo input device\033[0m" && exit
	input_dev=`ifconfig -a |grep -o $device`
	[[ $device != $input_dev ]] && echo -e "\033[33mDevice not found\033[0m" && exit
}

check_file(){
	[[ $maclist = "" ]] && echo -e "\033[33mNo input file\033[0m" && exit
	[[ ! -e $maclist ]] && echo -e "\033[33mFile not exist\033[0m" && exit
	[[ ! -f $maclist ]] && echo -e "\033[31mInvalid file\033[0m" && exit
	location=$(basename $maclist |grep -oE ^.*[\.]?)
}

gen_ssid(){
	check_dev
	check_file
	spoof
}

gen_ssid
