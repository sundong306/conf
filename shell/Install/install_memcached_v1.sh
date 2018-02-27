#!/bin/bash
#####contact: sundong306@foxmail.com
#####https://github.com/memcached/memcached/wiki
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


##安装memcached 1.4
mkdir  -p  /data/opt/tool
cd /data/opt/tool
yum install libevent-devel  -y
wget http://www.memcached.org/files/memcached-1.4.32.tar.gz
tar zxf memcached-1.4.32.tar.gz
cd memcached-1.4.32
./configure --prefix=/data/opt/memcached
check_ok
make && make install
check_ok
/data/opt/memcached/bin/memcached  -d -m 64 -u root -l 127.0.0.1  -p 11211 -c 512 -P /tmp/memcached.pid
check_ok


##iptables  11211
iptables  -A  INPUT  -s  10.192.147.0/24  -p tcp  --dport 11211  -j ACCEPT
iptables  -A  INPUT   -p tcp  --dport 11211  -j DROP
