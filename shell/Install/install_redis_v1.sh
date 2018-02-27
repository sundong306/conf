#!/bin/bash
#####contact: sundong306@foxmail.com
#####参考文档 http://redis.cn/download.html http://ask.apelearn.com/question/9286
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

##安装redis
mkdir  -p  /data/opt/tool
cd /data/opt/tool
wget http://download.redis.io/releases/redis-3.2.3.tar.gz
tar xzf redis-3.2.3.tar.gz
cd redis-3.2.3
make
check_ok
cd  ./src
./redis-server &
check_ok
sleep  10
yum  install  -y  lsof
lsof -i:6379
check_ok

##优化
#echo never > /sys/kernel/mm/transparent_hugepage/enabled
#cat  >>  /etc/rc.local << eof
#echo never > /sys/kernel/mm/transparent_hugepage/enabled
#eof


##iptables  6379
iptables  -A  INPUT  -s  10.192.147.0/24  -p tcp  --dport 6379  -j ACCEPT
iptables  -A  INPUT   -p tcp  --dport 6379  -j DROP


printf  "redis  is  install  ok"
