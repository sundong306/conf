#!/bin/sh
IPTABLES=/sbin/iptables

$IPTABLES -F -t filter
$IPTABLES -F -t nat
$IPTABLES -F -t mangle

$IPTABLES -X -t filter
$IPTABLES -X -t nat
$IPTABLES -X -t mangle

$IPTABLES -Z -t filter
$IPTABLES -Z -t nat
$IPTABLES -Z -t mangle

$IPTABLES -t filter -P INPUT     DROP
$IPTABLES -t filter -P OUTPUT    ACCEPT
$IPTABLES -t filter -P FORWARD   ACCEPT

$IPTABLES -t nat -P PREROUTING   ACCEPT
$IPTABLES -t nat -P POSTROUTING  ACCEPT
$IPTABLES -t nat -P OUTPUT       ACCEPT

$IPTABLES -t mangle -P INPUT     ACCEPT
$IPTABLES -t mangle -P OUTPUT    ACCEPT
$IPTABLES -t mangle -P FORWARD   ACCEPT

$IPTABLES -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPTABLES -A INPUT -i lo -j ACCEPT
$IPTABLES -A INPUT -p tcp -m multiport  --dport 22,80,443,4505,4506  -j ACCEPT

###   service: ssh  web  ss svn icmp
$IPTABLES -A INPUT -p icmp   -j ACCEPT 
$IPTABLES -A INPUT -p tcp --dport 1024:65535 -j ACCEPT
