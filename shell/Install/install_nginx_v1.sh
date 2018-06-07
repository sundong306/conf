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


##安装nginx
cd /opt ;  wget  https://www.openssl.org/source/openssl-1.0.2g.tar.gz  ; tar zxf  openssl-1.0.2g.tar.gz
cd  openssl-1.0.2g ;  ./config  ; make ;  make install ; openssl version
cd /opt  ;  wget  http://nginx.org/download/nginx-1.12.0.tar.gz  ;tar  zxf  nginx-1.12.0.tar.gz 
cd  nginx-1.12.0 
yum install  -y  pcre*  zlib*    gcc     openssl  openssl-devel  libxml*  libxslt*   gd-devel  GeoIP GeoIP-data GeoIP-devel  perl-devel perl-ExtUtils-Embed  gcc-c++
./configure  --prefix=/usr/local/nginx --user=www --group=www --with-http_stub_status_module --with-http_ssl_module --with-http_realip_module --with-http_geoip_module --with-stream --with-http_v2_module   --with-openssl=/root/openssl-1.0.2g
make  && make  install
useradd  -M   -s /sbin/nologin  www
/usr/local/nginx/sbin/nginx  -V
