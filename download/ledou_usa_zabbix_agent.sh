#!/bin/bash
#####contact: sundong306@foxmail.com
##
## 非root用户无法执行  
if [ $USER != root ]
then
        echo "only root can run this script!"
        exit 1
fi

##判断脚本执行情况
check_ok() {
if [ $? != 0 ]
then
echo "Error, Check the error log."
exit 1
fi
}

##安装 zabbix  agentd
groupadd zabbix 
useradd -g zabbix zabbix
cd  /tmp 
apt-get install libpcre3 libpcre3-dev  -y
wget https://github.com/sundong306/conf/raw/master/download/zabbix-3.4.11.tar.gz
tar  zxf zabbix-3.4.11.tar.gz
cd  /tmp/zabbix-3.4.11
mkdir -p /data/app/zabbix
./configure --prefix=/data/app/zabbix  --enable-agent
make  install
>  /data/app/zabbix/etc/zabbix_agentd.conf
cat << EOF >  /data/app/zabbix/etc/zabbix_agentd.conf
PidFile=/tmp/zabbix_agentd.pid
LogFile=/tmp/zabbix_agentd.log
LogFileSize=0
Server=10.4.0.17
ServerActive=10.4.0.17
Include=/data/app/zabbix/etc/zabbix_agentd.conf.d/*.conf
HostMetadataItem=system.uname
Timeout=8
EOF
/data/app/zabbix/sbin/zabbix_agentd -c /data/app/zabbix/etc/zabbix_agentd.conf   ;  lsof  -i:10050
echo "/data/app/zabbix/sbin/zabbix_agentd -c /data/app/zabbix/etc/zabbix_agentd.conf" >> /etc/rc.local


