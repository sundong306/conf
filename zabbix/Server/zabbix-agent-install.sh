#!/bin/bash
### only root can run this script.
### CentOS  6	7
if [ $USER != root ]
then
	echo "only root can run this script!"
	exit 1
fi

Release=`cat /etc/redhat-release | awk -F "release" '{print $2}' |awk -F "." '{print $1}' |sed 's/ //g'`
case  "$Release" in
	6)
		echo  "Release  is OK !"
              ;;
	7)
		echo  "Release  is OK !"
              ;;
	*)
		echo "only CentOS  6  7  can run this script!"
		exit 1
esac

Redhat=`cat /etc/redhat-release`
Hostip=`curl -s https://api.ip.sb/ip`

echo "本机系统为:$Redhat"
echo "本机ip为:$Hostip"
sleep 10

#### 0. initialize
cd /opt ; wget https://raw.githubusercontent.com/sundong306/conf/master/shell/Webinitialize.sh
chmod u+x Webinitialize.sh ; /opt/Webinitialize.sh

#### 1. install  
cd /opt
rpm  -ivh    http://repo.zabbix.com/zabbix/3.4/rhel/6/x86_64/zabbix-release-3.4-1.el6.noarch.rpm
yum clean all  ; yum  makecache
yum install zabbix-agent  -y
[ $?  = 0  ] || exit 1 
service zabbix-agent start

#### 2. modify
cd /etc/zabbix/
# diskstats user parameters config
mkdir -p /etc/zabbix/zabbix_agentd.d/	;  cd /etc/zabbix/zabbix_agentd.d/
wget https://raw.githubusercontent.com/grundic/zabbix-disk-performance/master/userparameter_diskstats.conf 
cd	/etc/zabbix/  ;  rm -rf  zabbix_agentd.conf
wget https://raw.githubusercontent.com/sundong306/conf/master/zabbix/Server/zabbix_agentd.conf
sed -i "s/Hostname=101.132.79.226/Hostname=${Hostip}/g"  zabbix_agentd.conf
# low level discovery script
wget https://raw.githubusercontent.com/grundic/zabbix-disk-performance/master/lld-disks.py -O /usr/local/bin/lld-disks.py
chmod u+x /usr/local/bin/lld-disks.py
service zabbix-agent restart


#### 3. echo 
echo -e  " zabbix agent install is ok  \033[32mDone\033[0m"


