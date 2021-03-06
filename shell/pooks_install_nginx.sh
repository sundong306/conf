#!/bin/bash
#####contact: sundong306@foxmail.com
########################################
#
# OS:CentOS  7
# install nginx  1.16
#
########################################

##root
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

# 变量
nginx_version=1.16.0
nginx_download=/opt/download
nginx_home=/data/app/nginx
mkdir  -p  ${nginx_home}  ${nginx_download}

# yum
yum install -y pcre-devel zlib-devel openssl-devel   gd-devel  GeoIP GeoIP-data GeoIP-devel   perl-ExtUtils-Embed  gcc-c++

# openssl
cd ${nginx_download}
wget  https://www.openssl.org/source/openssl-1.1.1b.tar.gz  ; tar zxf  openssl-1.1.1b.tar.gz 
cd  openssl-1.1.1b ;  ./config  ; make ;  make install ; ./openssl version

# nginx
cd ${nginx_download}
wget http://nginx.org/download/nginx-${nginx_version}.tar.gz
tar zxf  nginx-${nginx_version}.tar.gz
cd ./nginx-${nginx_version}

# make
./configure --prefix=${nginx_home} --user=www --group=www  --with-http_ssl_module  --with-stream  --with-stream_realip_module   --with-http_v2_module   --with-openssl=${nginx_download}/openssl-1.1.1b
make & make install
check_ok
useradd  -M   -s /sbin/nologin  www
rm -rf  /usr/sbin/nginx
ln -s ${nginx_home}/sbin/nginx /usr/sbin/nginx
nginx  -V
nginx  -t

echo  "`date`"  >  ${nginx_home}/html/1.html
# config
#cp ${nginx_home}/conf/nginx.conf ${nginx_home}/conf/nginx.conf.bak
#wget  https://raw.githubusercontent.com/sundong306/conf/master/download/pooks_http_nginx.conf  -O  ${nginx_home}/conf/nginx.conf

