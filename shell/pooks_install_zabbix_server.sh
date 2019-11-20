#!/bin/bash
#####contact: sundong306@foxmail.com
########################################
#
# OS:CentOS  7 
# install zabbix server   4.0
#
########################################

##root
if [ $USER != root ]
then
        echo "only root can run this script!"
        exit 1
fi


### 
rpm -Uvh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
yum -y install zabbix-server-mysql zabbix-web-mysql zabbix-agent  mysql-server 
service  mysqld  start

###
mysqladmin -u root password "ld@2018"
/usr/bin/mysql -uroot  -pld@2018  -h127.0.0.1  -e "create database zabbix character set utf8 collate utf8_bin;"
/usr/bin/mysql -uroot  -pld@2018  -h127.0.0.1  -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'ld@2018';"
zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | /usr/bin/mysql -uzabbix -p'ld@2018' zabbix

###
wget  https://raw.githubusercontent.com/sundong306/conf/master/download/pooks_zabbix_server.conf  -O  /etc/zabbix/zabbix_server.conf
wget  https://raw.githubusercontent.com/sundong306/conf/master/download/pooks_httpd_zabbix.conf  -O  /etc/httpd/conf.d/zabbix.conf

###
mkdir  /usr/share/zabbix/fonts
cd  /usr/share/zabbix/fonts
wget https://github.com/sundong306/conf/raw/master/download/msyh.ttf
cd  /etc/alternatives/  ;  rm  -rf  zabbix-frontend-font  zabbix-web-font   
ln -s /usr/share/zabbix/fonts/msyh.ttf zabbix-frontend-font  
ln -s  /usr/share/zabbix/fonts/msyh.ttf   zabbix-web-font


###
systemctl restart zabbix-server zabbix-agent httpd mysqld
systemctl enable zabbix-server zabbix-agent httpd  mysqld

IP=`curl  -s  ip.sb`
echo      "访问 http://$IP/zabbix   完成安装zabbix server  4.0"


