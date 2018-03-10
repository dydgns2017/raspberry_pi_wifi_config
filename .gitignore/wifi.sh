#!/bin/bash

# static ip configuration
yonghoon="interface wlan0
static ip_address=192.168.0.10/24"
sudo sh -c " echo \"$yonghoon\" >> /etc/dhcpcd.conf "
# dnsmasq original file backup and configuration
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
yonghoon="
interface=wlan0
  dhcp-range=192.168.0.11,192.168.0.30,255.255.255.0,24h
"
sudo sh -c " echo \"$yonghoon\" >> /etc/dnsmasq.conf "
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
sudo sh -c " echo \"$yonghoon\" >> /etc/hostapd/hostapd.conf "

yonghoon="
DAEMON_CONF=\"/etc/hostapd/hostapd.conf\"
"
sudo sh -c " echo \"$yonghoon\" >> /etc/default/hostapd "

sudo sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g" /etc/sysctl.conf

sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
sudo iptables-restore < /etc/iptables.ipv4.nat

sudo brctl addbr br0
sudo brctl addif br0 eth0
yonghoon="
auto br0
iface br0 inet manual
bridge_ports eth0 wlan0
"
sudo sh -c " echo \"$yonghoon\" >> /etc/network/interfaces "
