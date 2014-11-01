#!/bin/sh

if `ip route list | grep default | grep -v tun`; then
	# default gateway is not on tun device

	GATEWAY_DEFAULT=$(ip route list | sed -n -e "s/^default.*[[:space:]]\([[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+\).*/\1/p")

	for cfg in `ls /etc/openvpn/*.conf`; do
		for ip in `cat $cfg | grep remote | grep -v '#' | awk '{print $2}'`; do
			route del $ip
			route add $ip gw $GATEWAY_DEFAULT
		done
	done

	route del default
	/etc/init.d/openvpn restart
else
	echo 'default gateway is already on vpn'
fi
