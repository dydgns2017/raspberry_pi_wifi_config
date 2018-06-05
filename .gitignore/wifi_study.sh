#!/bin/bash
# copyright Yonghoong
# Auto configuration AP and isc-dhcp-server


## set up isc-dhcp-server

sudo mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.orig

Yonghoon="subnet 192.168.100.0 netmask 255.255.255.0 {
   authoritative;
   range 192.168.100.10 192.168.100.200;
   default-lease-time 3600;
   max-lease-time 3600;
   option subnet-mask 255.255.255.0;
   option broadcast-address 192.168.100.255;
   option routers 192.168.100.1;
   option domain-name-servers 1.1.1.1;
}
"

sudo sh -c " echo \"$Yonghoon\" >> /etc/dhcp/dhcpd.conf"

sudo mv /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.orig

Yonghoon="DHCPDv4_CONF=/etc/dhcp/dhcpd.conf
INTERFACES=\"wlan0\""

sudo sh -c " echo \"$Yonghoon\" >> /etc/default/isc-dhcp-server "

## AP configuration

read -p "Configuration your WI-FI name = " NETWORK
read -p "Configuration your WI-FI password = " PASS

Yonghoon="
interface=wlan0
#driver=rtl871xdrv
ssid=$NETWORK
country_code=US
hw_mode=g
channel=6
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=$PASS
wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP
wpa_group_rekey=86400
ieee80211n=1
wme_enabled=1
"

sudo sh -c " echo \"$Yonghoon\" >> /etc/hostapd/hostapd.conf "

Yonghoon="
DAEMON_CONF=\"/etc/hostapd/hostapd.conf\"
"
sudo sh -c " echo \"$Yonghoon\" >> /etc/default/hostapd"
sudo sed -i 's/DAEMON_CONF=/DAEMON_CONF=\/etc\/hostapd\/hostapd.conf/g' /etc/init.d/hostapd

## static ip address interface 'wlan0'

sudo mv /etc/dhcpcd.conf /etc/dhcpcd.conf.orig

Yonghoon="interface wlan0
static ip_address=192.168.100.1
static routers=192.168.100.1
static domain_name_servers=1.1.1.1"

sudo sh -c " echo \"$Yonghoon\" >> /etc/dhcpcd.conf"
