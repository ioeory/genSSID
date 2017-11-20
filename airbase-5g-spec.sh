#!/bin/bash
maclist=$1
device=$2
location=$(basename $1 |grep -oE ^.*[\.]?)

spoof(){
#       airbase-ng  -e 1111111111111 -c 40  -w "1234567890"  $device &

        for mac in $(grep  -E ^[^#] $maclist)
        do
                let i=i+1
                #let essid=essid+111
                essid=$(cat /dev/urandom | head -n 10 | md5sum | head -c 11)
                sleep 1
                clear
                airbase-ng -e $essid -c 36 -a "$mac" $device &
                echo "Starting $location-$i"
                echo "SSID:$essid... "
                echo "MAC:$mac"
        done

}

if [ $UID -ne 0 ];then
        echo "This Script Must Run As Root..."
        exit
fi

pkill airbase-ng

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
#       device="wlan0"
#       echo "try using $device.."
        exit
else
        ifconfig  -a |grep $device
        if [ $? != 0 ];then
                echo "device not found.."
                exit
        fi
fi

spoof
sleep 1
