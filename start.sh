#!/bin/bash
echo "Enter VPN server address(ex:52.522.522.522): "
read VPN_SERVER_IP

echo '\n'
echo 'Executing: `ip route`'
ip route
echo 'Enter value of X.X.X.X, from: default via X.X.X.X ...'
read GATEWAY_IP
echo '\n'

mkdir -p /var/run/xl2tpd
touch /var/run/xl2tpd/l2tp-control

service strongswan restart
service xl2tpd restart

#start the service
ipsec up myvpn

echo "c myvpn" > /var/run/xl2tpd/l2tp-control

route add $VPN_SERVER_IP gw $GATEWAY_IP

PUBLIC_IP=$(wget -t 3 -T 15 -qO- http://ipv4.icanhazip.com)
route add $PUBLIC_IP gw $GATEWAY_IP;


route add default dev ppp0

echo 'Verify that your traffic is being routed properly. The bellow ip should be your VPN server IP.'
wget -qO- http://ipv4.icanhazip.com; echo

exit 0

