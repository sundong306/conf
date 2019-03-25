#!/bin/bash
cd  /opt
Name=$1

echo ${Name}
wget http://repo.zabbix.com/zabbix/3.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.4-1+trusty_all.deb
dpkg -i zabbix-release_3.4-1+trusty_all.deb
apt-get update
apt-get install zabbix-agent
sed  -i   '/#/d;/^$/d'  /etc/zabbix/zabbix_agentd.conf 
sed  -i  's/Server=127.0.0.1/Server=10.0.4.11/g'  /etc/zabbix/zabbix_agentd.conf
sed  -i  's/ServerActive=127.0.0.1/ServerActive=10.0.4.11/g'   /etc/zabbix/zabbix_agentd.conf
sed  -i  "s/Hostname=Zabbix server/Hostname=${Name}/g" /etc/zabbix/zabbix_agentd.conf
echo "HostMetadataItem=system.uname"   >> /etc/zabbix/zabbix_agentd.conf
service  zabbix-agent restart
