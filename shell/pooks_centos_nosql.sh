#!/bin/bash
#####contact: sundong306@foxmail.com
########################################
# 腾讯云 购买DB资源
# OS:CentOS  7
# memcached   https://www.runoob.com/memcached/memcached-install.html 
# redis       https://www.runoob.com/redis/redis-intro.html
# mongodb-org https://www.runoob.com/mongodb/mongodb-intro.html
# postgresql  https://www.runoob.com/postgresql/linux-install-postgresql.html

########################################


#1. memcached 1.4
install_memcached  () {
	yum install memcached  -y
	/usr/bin/memcached -d -m 64M -u root -l 127.0.0.1 -p 11211 -c 256 -P /tmp/memcached.pid
	netstat  -lnpt  | grep memcached
	echo  -e   " \n\033[32m 1. Memcached 1.4    telnet  127.0.0.1  11211   .......... \033[0m "
}



#2. redis 3.2
install_redis  ()  {
	yum  install  redis  -y
	wget https://raw.githubusercontent.com/sundong306/conf/master/download/pooks_redis.conf -O  /etc/redis.conf
	service redis  start
	systemctl enable  redis
	netstat  -lnpt  | grep redis
	echo  -e   " \n\033[32m 3. redis 3.2      redis-cli  -h  127.0.0.1  -p 6379  -a '123456'  .......... \033[0m "
}


#3. mongoDB  3.6
install_mongodb ()  {
	wget  https://raw.githubusercontent.com/sundong306/conf/master/download/pooks_mongodb-org-3.6.repo  -O   /etc/yum.repos.d/pooks_mongodb-org-3.6.repo
	yum install -y mongodb-org
	wget  https://raw.githubusercontent.com/sundong306/conf/master/Pook/Shell/Install/limits.conf   -O       /etc/security/limits.conf
	echo never > /sys/kernel/mm/transparent_hugepage/enabled
	echo never > /sys/kernel/mm/transparent_hugepage/defrag
	wget  https://raw.githubusercontent.com/sundong306/conf/master/download/pooks_mongod_3.6.conf   -O       /etc/mongod.conf
	service  mongod  start
	systemctl enable  mongod
	netstat  -lnpt  | grep mongod
	echo  -e   " \n\033[32m 3. mongoDB 3.6    mongo  --port 27017 -u "admin" -p "123456" --authenticationDatabase "admin"      .......... \033[0m "
}


#4.  pgsql   9.5
install_pgsql ()  {
	rpm  -ivh  https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-3.noarch.rpm
	yum install postgresql95-server postgresql95-contrib  -y
	/usr/pgsql-9.5/bin/postgresql95-setup initdb
	systemctl enable postgresql-9.5.service
	systemctl start postgresql-9.5.service
	netstat  -lnpt  | grep postgresql
	echo  -e   " \n\033[32m 3. pgsql   9.5         .......... \033[0m "
}



