#!/bin/bash
### only root can run this script.
### CentOS  7
if [ $USER != root ]
then
	echo "only root can run this script!"
	exit 1
fi

Release=`cat /etc/redhat-release | awk -F "release" '{print $2}' |awk -F "." '{print $1}' |sed 's/ //g'`
case  "$Release" in
	7)
		echo  "Release  is OK !"
              ;;
	*)
		echo "only CentOS  7 can run this script!"
		exit 1
esac

Redhat=`cat /etc/redhat-release`
Hostip=`curl -s https://api.ip.sb/ip`

echo "本机系统为:$Redhat"
echo "本机ip为:$Hostip"
sleep 10


#### 1. install  
yum  install -y gcc   gcc-c++  make openssl-devel   patch unzip perl   git vixie-cron crontabs
yum  install -y tree net-tools bind-utils tree sysstat vim-en* lrzsz  iftop tcpdump telnet traceroute
yum  install -y trousers   gnutls  wget lsof
mkdir -p /root/install/  && cd   /root/install/
wget http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
rpm -ivh  zabbix-release-3.4-2.el7.noarch.rpm
yum install zabbix-server-mysql zabbix-web-mysql  zabbix-agent  -y
wget http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm
rpm -ivh mysql-community-release-el7-5.noarch.rpm
yum install mysql-community-server -y
systemctl start mysqld

#### 2. modify
echo "设置数据库root密码,默认为123321"
sleep 3
mysqladmin  -uroot password "123321"
echo "创建zabbix数据库，和用户名密码"
echo "create database IF NOT EXISTS zabbix default charset utf8 COLLATE utf8_general_ci;" | mysql -uroot -p123321
echo "grant all privileges on zabbix.* to zabbix@'localhost' identified by 'zabbix';" | mysql -uroot -p123321
echo "flush privileges;" | mysql -uroot -p123321
sleep 3
cd /usr/share/doc/zabbix-server-mysql-3.4.1/
zcat create.sql.gz | mysql -uroot zabbix
cd /etc/zabbix &&  mv  zabbix_server.conf  zabbix_server.conf.bak &&  mv  zabbix_agentd.conf zabbix_agentd.conf.bak
wget  https://raw.githubusercontent.com/sundong306/conf/master/zabbix/Server/zabbix_server.conf
wget  https://raw.githubusercontent.com/sundong306/conf/master/zabbix/Server/zabbix_agentd.conf
chmod 644  /etc/zabbix/zabbix_*.conf
sed -i "s/;date.timezone =/date.timezone =Asia\/Shanghai/g" /etc/php.ini
systemctl start  zabbix-agent ; systemctl start  zabbix-server ; systemctl start  httpd 
lsof -i:80 && lsof -i:10050 && lsof -i:10051 && echo $?
echo "设置开机启动"
systemctl on  zabbix-agent ; systemctl on  zabbix-server ; systemctl on  httpd ; systemctl on mysqld


#### 3. echo 
echo "启动的端口$Port"
echo "打开http://$Hostip/zabbix，进行下一步安装"


