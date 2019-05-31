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

gen_ssid(){
	airmon-ng check kill
	pkill airbase-ng
	for ((i=0;i<$NUM;i++))
	do
		BSSID=$(dd if=/dev/urandom count=1  2>/dev/null | md5sum | sed 's/^\(.\)\(..\)\(..\)\(..\)\(..\)\(..\).*$/\14:\2:\3:\4:\5:\6/g')
		SLASH=${SLASHS[$RANDOM % ${#SLASHS[@]}]}
		SUBFIX=$(echo $BSSID|awk 'BEGIN{FS=":"} {print toupper($1$2$3)}')		
		SSID=${SSIDB[$RANDOM % ${#SSIDB[@]}]}$SLASH$SUBFIX
		echo "#${SSID}" >>$SSID_LIST
		echo "${BSSID}" >>$SSID_LIST
		clear
		#airbase-ng -e $SSID -c 36 -w 1234567890 -a $BSSID wlan1 & 
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
	[[ $NUM -eq "" ]] && NUM=11 ; echo -e "\033[33m Nothing spec will generate $NUM SSID\033[0m"
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

