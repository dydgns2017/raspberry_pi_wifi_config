#!/bin/bash

read -p "Configuration your WI-FI name = " NETWORK
read -p "Configuration your WI-FI password = " PASS
yonghoon="
interface=wlan0
bridge=br0
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
ssid=$NETWORK
wpa_passphrase=$PASS
"
echo $yonghoon
