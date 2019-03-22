#!/bin/bash
#####contact: sundong306@foxmail.com
#####https://www.nginx.com/resources/admin-guide/installing-nginx-open-source/
########################################
#
# OS:CentOS 7  
#
########################################

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

yum install  -y  pcre*  zlib*    gcc     openssl  openssl-devel  libxml*  libxslt*   gd-devel  GeoIP GeoIP-data GeoIP-devel  perl-devel perl-ExtUtils-Embed  gcc-c++

##安装nginx
cd /opt ;  wget  https://www.openssl.org/source/openssl-1.1.1b.tar.gz  ; tar zxf  openssl-1.1.1b.tar.gz 
#cd  openssl-1.1.1b ;  ./config  ; make ;  make install ; openssl version
cd  openssl-1.1.1b ;  openssl version
cd /opt  ;  wget  https://nginx.org/download/nginx-1.15.9.tar.gz  ;tar  zxf  nginx-1.15.9.tar.gz 
cd  nginx-1.15.9
./configure  --prefix=/usr/local/nginx --user=www --group=www  --with-http_ssl_module  --with-stream  --with-stream_realip_module   --with-http_v2_module   --with-openssl=/opt/openssl-1.1.1b    --with-openssl-opt='enable-tls1_3 enable-weak-ssl-ciphers'
make  && make  install
useradd  -M   -s /sbin/nologin  www
/usr/local/nginx/sbin/nginx  -V
