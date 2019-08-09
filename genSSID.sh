#!/bin/bash
NUM=$1
SSID_LIST=ssid-`date +%Y%m%d%H%M%S`.list
DEV=wlan1
SSIDB=(TP-Link DLink  Linksys OpenWrt PDCN Asus AsusROG AsusRT \
TpLink  Tenda Net-core Aruba TotoLink Cisco NetGear XiaoMi Mercury \
Fast Phicomm Spark Z-Com Accton CoCom BLink JCG Buffalo Belkin ZTE \
HuaWei Trendnet Jetstream  Ubnt Zyxel Ruckus Alvarion Ubiquiti Serria \
Proxim Xirrus Meru Avaya  Cerio Ciena )
SLASHS=(- _ "" Home Office Outdoor "" "" "" "" "" "" "" "" "" "" )
BSSIDV=("3c:46:d8:" "3c:47:11:" "44:94:fc:" "64:cc:2e:" "d8:50:e6:" "6c:19:8f:" "6c:5e:7a:" "6c:8b:2f:" "6c:b0:ce:" "00:14:6c:" "00:14:7c:" "48:f8:b3:" "b8:3a:08:" "bc:ad:ab:" "bc:ee:7b:" "c8:7b:5b:" "cc:c3:ea:" "d4:55:be:")
gen_ssid(){
	airmon-ng check kill
	pkill airbase-ng
	for ((i=0;i<$NUM;i++))
	do
#FULL MAC 
#BSSID=$(dd if=/dev/urandom count=1  2>/dev/null | md5sum | sed 's/^\(.\)\(..\)\(..\)\(..\)\(..\)\(..\).*$/\14:\2:\3:\4:\5:\6/g')
		BSSID=${BSSIDV[$RANDOM % ${#BSSIDV[@]}]}$(dd if=/dev/urandom count=1  2>/dev/null | md5sum | sed 's/^\(.\)\(..\)\(..\)\(..\)\(..\)\(..\).*$/\14:\2:\3/g')
		SLASH=${SLASHS[$RANDOM % ${#SLASHS[@]}]}
		SUBFIX=$(echo $BSSID|awk 'BEGIN{FS=":"} {print toupper($1$2$3)}')		
		SSID=${SSIDB[$RANDOM % ${#SSIDB[@]}]}$SLASH$SUBFIX
		sleep 1
		echo "#${SSID}" #>>$SSID_LIST
		echo "${BSSID}" #>>$SSID_LIST
		clear
		airbase-ng -e $SSID -c 36 -w 1234567890 -a $BSSID $DEV & 
		echo -e "\033[33mGenerating $SSID with MAC $BSSID\033[0m"
		sleep 1
	done

	clear
	cat $SSID_LIST
	echo -e "\033[32m$i SSID has been generated..\033[0m"
	
}

check_dev(){
	[[ $UID -ne 0 ]] && echo -e "\033[31m This script must run as root! \033[0m" && exit
	input_dev=`ifconfig -a |grep -o $DEV`
	[[ $DEV != $input_dev ]] && echo -e "\033[33mDevice not found \033[0m" && exit
}

check_num(){
	[[ $UID -ne 0 ]] && echo -e "\033[31m This script must run as root! \033[0m" && exit
	[[ $NUM -eq "" ]] && echo -e "\033[33m Nothing spec will generate 12 SSID\033[0m" && NUM=15 ; 
	#[[ $NUM -eq "" ]] && echo -e "\033[33m INPUT  SSIDS YOU WANT TO GENERATE\033[0m"  && exit
	[[ $NUM -lt 7 || $NUM -gt 50 ]] && echo -e "\033[33mRANGE:7-50\033[0m" && exit
	[[ ! -f $SSID_LIST ]] && echo "" >$SSID_LIST
}

main(){
	check_dev
	check_num
	gen_ssid
}

main

