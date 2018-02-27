#!/bin/bash

# DELL BMC Configuration 

########################  Set variable  ########################

IP1="192.168.18"
IP2="118.242.2"
IP3="118.242.24"
IP4="118.26.160"
IP5="114.113.147"
IP6="116.90.86"
IP7="192.168.17"

BMCIP1="10.10.18"
BMCIP2="10.10.0"
BMCIP3="10.10.1"
BMCIP4="10.11.0"
BMCIP5="10.11.1"
BMCIP6="10.11.2"
BMCIP7="10.10.17"

MASK="255.255.255.0"
SN=`dmidecode | sed -n '/^System Information/,/Serial Number/p' | tail -1 | awk -F ': ' '{print $2}'`
PN=`dmidecode | sed -n '/^System Information/,/Product Name/p' | tail -1 | awk -F ': ' '{print $2}'`

########################  Configuration BMC  ###################



ConfigBMC() {

	# << Configuration BMC parameters >>
	# 
	# IP address
	# netmask
	# default gateway
	# enabled channel
	# disenable arp generate
	# BMC default user(root) password
	
	ipmitool lan set 1 ipsrc static > /dev/null && echo IPSRC OK
		# wait
	ipmitool lan set 1 ipaddr $BMCIP > /dev/null && echo IPADR OK
		# wait
	ipmitool lan set 1 netmask $MASK > /dev/null && echo NETMASK OK
		# wait
	ipmitool lan set 1 defgw ipaddr $BMCGW > /dev/null && echo DEFGW OK
		# wait
	ipmitool lan set 1 access on > /dev/null && echo ACCESS ON
		# wait
	ipmitool lan set 1 arp generate off > /dev/null && echo ARP Generate Off
		# wait
	ipmitool user set password 2 'BKcs^2^5!1#3' > /dev/null 

	echo -ne "\n\033[42;37;1m BMC IP configurationa is complete. \033[0m\n\nIP:$NO1.$NO2\nPN: $PN\nSN:$SN\nBMC:\n`ipmitool lan print 1`\n"

	# Configuration system redirects
	#
	# Add console kernel modules
	# Add login terminal
	# Add user security control
	
#	grep "console=ttyS1,115200" /boot/grub/grub.conf > /dev/null
#	if [ $? = 1 ];then
#		sed -i '/^[^ ]*kernel/s/\(.*\)/\1 console=ttyS1,115200/' /boot/grub/grub.conf
#	fi
	
		
#	grep "115200 ttyS1 vt100" /etc/inittab > /dev/null
#	if [ $? = 1 ];then
#		echo "s1:12345:respawn:/sbin/agetty -h -L 115200 ttyS1 vt100" >> /etc/inittab
#	fi

	
#	grep "ttyS1" /etc/securetty > /dev/null
#	if [ $? = 1 ];then
#		echo "ttyS1" >> /etc/securetty
#	fi
	
#	echo -ne "\n\033[42;37;1m System Redirects Finished. \033[0m\n\nIP:$NO1.$NO2\nPN: $PN\nSN:$SN\nBMC:\n`ipmitool lan print 1`\n"
}


########################  Testing environment  #################

#
# Check outbound allowed to yum source
# Check the YUM configuration files (boke. Repo) exists
# check that the IPMI package is installed
# Check IPMI service startup 
#

/sbin/iptables -nL | grep "118.242.16.52" | grep "dpt:65165" > /dev/null
if [ $? = 1 ];then
	/sbin/iptables -A OUTPUT -d 118.242.16.52 -p tcp --dport 65165 -j ACCEPT
fi


if [ ! -f "/etc/yum.repos.d/boke.repo" ];then


	echo '[boke]' > /etc/yum.repos.d/boke.repo
	echo 'name=boke yum' >> /etc/yum.repos.d/boke.repo
	echo 'baseurl=http://y.pook.com:65165/CentOs/$releasever/$basearch' >> /etc/yum.repos.d/boke.repo
	echo 'enabled=1' >> /etc/yum.repos.d/boke.repo
	echo 'gpgcheck=0' >> /etc/yum.repos.d/boke.repo
	
	echo -e "\033[42;37m Creating boke.repo successful \033[0m"
fi


rpm -q ipmitool > /dev/null
if [ $? != 0 ];then

        yum install ipmitool -y

fi

rpm -q OpenIPMI-tools > /dev/null
if [ $? != 0 ];then

        yum install OpenIPMI-tools -y

fi

rpm -q acpid > /dev/null
if [ $? != 0 ];then

        yum install acpid -y

fi

rpm -q OpenIPMI > /dev/null
if [ $? != 0 ];then

        yum install OpenIPMI -y
        service ipmi start
        chkconfig ipmi on

else
	service ipmi status > /dev/null
	if [ $? != 0 ];then
		service ipmi start > /dev/null
		chkconfig ipmi on
	fi
fi

########################  Install Toolkit  #####################

#
# Check whether the network card 1 is enabled
# Matching network card 1 IP, Configuration corresponding BMC IP

/sbin/ifconfig | grep -E "eth0|em0|em1" > /dev/null

if [ $? = 0 ];then
	
	cd /etc/sysconfig/network-scripts/
	# NO1=`/sbin/ifconfig | grep -E -A 1 "em1|eth0" | grep inet | awk '{print $2}' | awk -F ":" '{print $2}' |cut -d "." -f 1-3`
	# NO1=`/sbin/ifconfig | awk -F '[ .:]*' 'NR==2{print$4"."$5"."$6}'`
	NO1=`cat ifcfg-eth0 ifcfg-em0 ifcfg-em1 2> /dev/null | grep IPADDR | head -1 | awk -F '[ =".]*' '{print$2"."$3"."$4}'` > /dev/null
	

	# NO2=`/sbin/ifconfig | grep -E -A 1 "em1|eth0" | grep inet | awk '{print $2}' | awk -F ":" '{print $2}' |awk -F "." '{print $4}'`
	# NO2=`/sbin/ifconfig | awk -F '[ .:]*' 'NR==2{print$7}'`
	NO2=`cat ifcfg-eth0 ifcfg-em0 ifcfg-em1 2> /dev/null | grep IPADDR | head -1 | awk -F '[ =".]*' '{print$5}'` > /dev/null
	

	case $NO1 in

		$IP1)
			BMCIP=$BMCIP1.$NO2
			BMCGW=10.10.16.1
			MASK="255.255.252.0"
			ConfigBMC
		;;

		$IP2)
			BMCIP=$BMCIP2.$NO2
			BMCGW=$BMCIP2.1
			ConfigBMC
		;;

		$IP3)
			BMCIP=$BMCIP3.$NO2
			BMCGW=$BMCIP3.1
			ConfigBMC
		;;
		
		$IP4)
			BMCIP=$BMCIP4.$NO2
			BMCGW=$BMCIP4.1
			ConfigBMC
		;;
		
		$IP5)
			BMCIP=$BMCIP5.$NO2
			BMCGW=$BMCIP5.1
			ConfigBMC
		;;
		
		$IP6)
			BMCIP=$BMCIP6.$NO2
			BMCGW=$BMCIP6.1
			ConfigBMC
		;;

		$IP7)
			BMCIP=$BMCIP7.$NO2
			BMCGW=10.10.16.1
			MASK="255.255.252.0"
			ConfigBMC
		;;
		
		*)
			echo -ne "\n\033[41;37;1;5m IP not matching \033[0m\n\nIP: $NO1.$NO2\nPN: $PN\nSN: $SN\n"
		;;
	esac

else
	IP=`/sbin/ifconfig | grep -E -A 1 "eth1|eth0|em2|em1"  | grep inet | awk '{print $2}' | awk -F ":" '{print $2}'`
	echo -ne "\n\033[41;37;1;5m network card 1 is not enabled \033[0m\n\nIP:$IP\nPN: $PN\nSN:$SN\n"
fi

