#!/bin/bash 


# installation configuration
NGINX_VERSION=1.16.0
NGINX_SRC_PATH=/opt
NGINX_BIN_PATH=/usr/local/nginx

# disable firewall
service iptables stop
setenforce 0

# installation dependence
yum install -y pcre-devel zlib-devel openssl-devel
yum install  -y  pcre*  zlib*    gcc     openssl  openssl-devel  libxml*  libxslt*   gd-devel  GeoIP GeoIP-data GeoIP-devel  perl-devel perl-ExtUtils-Embed  gcc-c++


# download nginx source package
cd ${NGINX_SRC_PATH}


# unzip source package
cd ${NGINX_SRC_PATH}
tar  zxf  nginx-${NGINX_VERSION}.tar.gz
cd ./nginx-${NGINX_VERSION}


# install nginx
./configure --prefix=${NGINX_BIN_PATH} --user=www --group=www  --with-http_ssl_module  --with-http_ssl_module  --with-stream   --with-http_v2_module 
make & make install

# add nginx to system service
ln -s ${NGINX_BIN_PATH}/sbin/nginx /usr/sbin/nginx
/usr/local/nginx/sbin/nginx   -t
/usr/local/nginx/sbin/nginx   -s reload
