#!/bin/bash

NUM=$1


[[ $NUM -eq "" ]] && echo "INPUT  SSIDS YOU WANT TO GENERATE"  && exit
[[ $NUM -lt 7 || $NUM -gt 50 ]] && echo "RANGE:7-50" && exit
SSIDB=(TP DLink  Linksys OpenWrt PDCN Asus TpLink  Tenda Net Aruba Toto)
SLASHS=(- _ "")
for ((i=0;i<$NUM;i++))
do
	SSID=${SSIDB[$RANDOM % ${#SSIDB[@]}]}
#	SSID_SUBFIX=$(dd if=/dev/urandom count=1 2>/dev/null | md5sum | sed 's/^\(.\)\(..\)\(..\).*$/\14\2\3/g')
	SLASH=${SLASHS[$RANDOM % ${#SLASHS[@]}]}		
	BSSID=$(dd if=/dev/urandom count=1 2>/dev/null | md5sum | sed 's/^\(.\)\(..\)\(..\)\(..\)\(..\)\(..\).*$/\14:\2:\3:\4:\5:\6/g')
	SUBFIX=$(echo $BSSID|awk 'BEGIN{FS=":"} {print toupper($1$2$3$4)}')
	echo $SSID$SLASH$SUBFIX
	echo $BSSID
done






#awk 'BEGIN{FS=":"}  {print toupper($1)}'
