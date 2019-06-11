#!/bin/bash


How to Install PHP 7, NGINX & MySQL 5.6 on CentOS/RHEL 7.4 & 6.9 
https://tecadmin.net/install-php-7-nginx-mysql-5-on-centos/ 
CentOS 6 LNMP 
yum install epel-release 
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm 
rpm -Uvh http://repo.mysql.com/mysql-community-release-el6-5.noarch.rpm 
yum --enablerepo=remi-php72 install php 
yum --enablerepo=remi-php72 install php-mysql php-xml php-soap php-xmlrpc php-mbstring php-json php-gd php-mcrypt 
yum --enablerepo=remi-php72 install php-fpm 
yum install nginx 
yum install mysql-server 
nginx -v ; mysql --version ; php -v

CentOS 7 LNMP 
yum install epel-release 
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm 
rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm 
yum --enablerepo=remi-php72 install php 
yum --enablerepo=remi-php72 install php-mysql php-xml php-soap php-xmlrpc php-mbstring php-json php-gd php-mcrypt 
yum --enablerepo=remi-php72 install php-fpm 
yum install nginx 
yum install mysql-server 
nginx -v ; mysql --version ; php -v
