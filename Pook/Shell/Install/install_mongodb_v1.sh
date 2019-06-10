#!/bin/bash
#####contact: sundong306@foxmail.com
#####https://docs.mongodb.com/manual/tutorial/install-mongodb-on-red-hat/
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


##添加mongodb.repo
cd /etc/yum.repos.d/
touch mongodb.repo
cat  >>  mongodb.repo  <<eof
[mongodb]
name=MongoDB Repository
baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/
gpgcheck=0
enabled=1
eof

yum makecache
yum install -y mongodb-org
check_ok
sed  -i  's/dbpath=\/var\/lib\/mongo/dbpath=\/data\/db/g'  /etc/mongod.conf
check_ok
sed  -i   '/^#/d;/^$/'d  /etc/mongod.conf
mkdir -p /data/db ; chown -R mongod:mongod /data/db
/etc/init.d/mongod start
check_ok
sleep  10
yum  install  -y  lsof
lsof -i:27017
check_ok

##iptables 
#iptables  -A  INPUT  -s  10.192.147.0/24  -p tcp  --dport 27017  -j ACCEPT
#iptables  -A  INPUT   -p tcp  --dport 27017  -j DROP



printf  "mongodb  is  install  ok"
