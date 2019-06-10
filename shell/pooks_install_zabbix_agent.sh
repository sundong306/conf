#!/bin/bash  
#####contact: sundong306@foxmail.com
########################################
#
# OS:CentOS   Ubuntu    Window 
# install zabbix agent   4.0
#
########################################

##root
if [ $USER != root ]
then
        echo "only root can run this script!"
        exit 1
fi


#### 1.CentOS 6   7
##导入源
rpm -Uvh https://repo.zabbix.com/zabbix/4.0/rhel/6/x86_64/zabbix-release-4.0-1.el6.noarch.rpm
rpm -Uvh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
##安装
yum  clean all
yum  install  zabbix-agent  -y
##修改配置
wget https://raw.githubusercontent.com/sundong306/conf/master/download/pooks_zabbix_agentd.conf -O /etc/zabbix/zabbix_agentd.conf
wget https://raw.githubusercontent.com/sundong306/conf/master/download/discovertcpport.sh  -O /etc/zabbix/zabbix_agentd.conf.d/discovertcpport.sh
chmod u+x /etc/zabbix/zabbix_agentd.conf.d/discovertcpport.sh 
chown  zabbix.zabbix  /etc/zabbix/zabbix_agentd.conf.d/discovertcpport.sh
service zabbix-agent restart

#### 2.Ubuntu 12:precise 14:trusty   16:xenial  18:bionic
##导入源
wget https://repo.zabbix.com/zabbix/4.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.0-2%2Btrusty_all.deb
dpkg -i zabbix-release_4.0-2+trusty_all.deb

wget https://repo.zabbix.com/zabbix/4.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.0-2%2Bxenial_all.deb
dpkg -i zabbix-release_4.0-2+xenial_all.deb

wget https://repo.zabbix.com/zabbix/4.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.0-2%2Bbionic_all.deb
dpkg -i zabbix-release_4.0-2+bionic_all.deb

##安装
apt-get install -y zabbix-agent
##修改配置
wget https://raw.githubusercontent.com/sundong306/conf/master/download/pooks_zabbix_agentd.conf -O /etc/zabbix/zabbix_agentd.conf
wget https://raw.githubusercontent.com/sundong306/conf/master/download/discovertcpport.sh  -O /etc/zabbix/zabbix_agentd.conf.d/discovertcpport.sh
chmod u+x /etc/zabbix/zabbix_agentd.conf.d/discovertcpport.sh 
chown  zabbix.zabbix  /etc/zabbix/zabbix_agentd.conf.d/discovertcpport.sh
service zabbix-agent restart


#### 3.  Windows  2003  2008  2012
wget  https://assets.zabbix.com/downloads/4.0.9/zabbix_agents-4.0.9-win-amd64.zip

wget  https://raw.githubusercontent.com/sundong306/conf/master/download/pooks_zabbix_agentd_win.conf   -O  C:\zabbix\conf\zabbix_agentd.win.conf

C:\zabbix\bin\zabbix_agentd.exe -c C:\zabbix\conf\zabbix_agentd.win.conf -i 



