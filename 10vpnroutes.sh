#!/bin/bash

set -x

# срабатывает и на tun интерфейс
IFACE="$1"

if [[ $IFACE == *tun* ]]; then
	echo 'tun iface'
	echo $IFACE
	exit 0
fi

DG_IFACE=`ip route list | grep 'default' | awk '{print $5}'`

if [[ $DG_IFACE == *tun* ]]; then
	echo 'default gateway is already on vpn'
	exit 0
fi

GATEWAY_DEFAULT=$(ip route list | sed -n -e "s/^default.*[[:space:]]\([[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+\).*/\1/p")

for cfg in `ls /etc/openvpn/*.conf`; do
	for ip in `cat $cfg | grep remote | grep -v '#' | awk '{print $2}'`; do
		route del $ip
		route add $ip gw $GATEWAY_DEFAULT
	done
done

route del default
/etc/init.d/openvpn restart
