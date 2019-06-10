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
	netstat  -lnpt  | grep redis
	echo  -e   " \n\033[32m 3. redis 3.2      redis-cli  -h  127.0.0.1  -p 6379  -a '123456'  .......... \033[0m "
}


#3. mongoDB  2.6
install_mongodb ()  {
	yum  install  mongodb-server  mongodb-test   mongodb  -y
	service  mongod  start
	netstat  -lnpt  | grep mongod
	echo  -e   " \n\033[32m 3. mongoDB 2.6    .......... \033[0m "
}


#4. postgresql  9.2
install_pgsql () {
	yum  install  postgresql   -y


}


