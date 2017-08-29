#!/bin/bash
##
### only root can run this script.
### CentOS  6
if [ $USER != root ]
then
        echo "only root can run this script!"
        exit 1
fi

####  1. nginx 1.12 
yum install gc gcc gcc-c++ pcre-devel zlib-devel make wget openssl-devel libxml2-devel libxslt-devel gd-devel perl-ExtUtils-Embed GeoIP-devel gperftools gperftools-devel libatomic_ops-devel perl-ExtUtils-Embed dpkg-dev libpcrecpp0 libgd2-xpm-dev libgeoip-dev libperl-dev -y
cd /opt 
wget  https://www.openssl.org/source/openssl-1.0.2l.tar.gz
wget http://nginx.org/download/nginx-1.12.1.tar.gz
tar zxf   openssl-1.0.2l.tar.gz  ; tar zxf  nginx-1.12.1.tar.gz
cd /opt/nginx-1.12.1 
./configure --prefix=/usr/local/nginx --with-stream  --with-http_ssl_module --with-http_v2_module  --with-openssl=/opt/openssl-1.0.2l
make && echo  $?
make install &&echo $?
useradd nginx
/usr/local/nginx/sbin/nginx  -t  && echo $?  &&  /usr/local/nginx/sbin/nginx

####  2. mysql 5.1
yum install   -y  mysql-server mysql mysql-devel 
service  mysqld  status
service  mysqld  start


####  3. php  5.6
cd /opt
yum install -y gcc gcc-c++ gd-devel libmcrypt-devel libcurl-devel openssl-devel zlib-devel 
wget http://php.net/distributions/php-5.6.22.tar.gz
tar zxf php-5.6.22.tar.gz
cd php-5.6.22
./configure --prefix=/usr/local/php --enable-fpm --enable-mysqlnd --enable-zip --enable-mbstring --enable-exif --with-fpm-user=nginx --with-fpm-group=nginx --with-openssl --with-mysql --with-mysqli --with-pdo-mysql --with-curl --with-zlib --with-gd --with-mcrypt
make && echo  $?
make install &&echo $?
cp php.ini-production /etc/php.ini
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
/usr/local/php/sbin/php-fpm  -v
/usr/local/php/sbin/php-fpm  -c  /etc/php.ini   && echo  $?

#### 4. Chevereto
#cat /usr/local/nginx/html/img/1.php 
#<?php
#    phpinfo();
#?>
cd /opt
yum  install  -y  git  sendmail
git  clone  https://github.com/Chevereto/Chevereto-Free.git
cp  -a  Chevereto-Free    /usr/local/html/img
cd   /usr/local/nginx/html/img/  ; chmod  -R 777   app  content images
cd  /usr/local/nginx/conf/
rm  -rf  nginx.conf   ;  wget    https://raw.githubusercontent.com/sundong306/conf/master/shell/Chevereto/nginx.conf
/usr/local/nginx/sbin/nginx -t && echo $? && /usr/local/nginx/sbin/nginx
mysql -uroot  -e "create database Chevereto"
mysql -uroot -e "grant all on Chevereto.* to 'Chevereto'@'127.0.0.1' identified by 'Chevereto';"


####  5.测试
#测试前做好域名解析 和 证书配置
####  END
