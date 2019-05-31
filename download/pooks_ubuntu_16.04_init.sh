#!/bin/bash


###############  ubuntu  16.04 初始化

##1. 更换到  阿里云 apt 源
cp  /etc/apt/sources.list  /etc/apt/sources.list.bak
wget  https://raw.githubusercontent.com/sundong306/conf/master/download/pooks_ubuntu_16_04_aliyun_sources.list  -O  /etc/apt/sources.list


##2. history  加上 时间戳
echo 'export HISTTIMEFORMAT="%F %T ${USER} "' >> /etc/profile
source   /etc/profile


##3. apt 安装基础工具
apt install lrzsz lsof expect nethogs net-tools ntpdate sysstat dos2unix  tree wget file tcpdump  dstat   fping  iotop mtr rsync  python-pip   -y


##4.修改ssh端口为 37878   允许root登录  修改sshd_config  
wget  https://raw.githubusercontent.com/sundong306/conf/master/download/pooks_ubuntu_16_04_aliyun_sshd_config -O   /etc/ssh/sshd_config


##5.增加swap 空间 默认2G 若有swap 则不增加
Swapon="`swapon -s  | wc  -l`"
if	[ $Swapon   -eq 0  ]
then
dd if=/dev/zero of=/root/swapfile bs=1M count=2048
mkswap /root/swapfile 
swapon /root/swapfile 
echo  "/root/swapfile swap swap defaults 0 0 "  >>  /etc/fstab
free  -m
fi


##6.mysql 5.5  
apt-get install mysql-server
#mysql  -h localhost  -uroot -p'Hawk@2018'


##7. psql  9.5
apt-get install postgresql
mkdir -p /data/postgres/pgsql/data
chown -R postgres.postgres /data/postgres/
ls  /usr/lib/postgresql/9.5/bin/initdb
su - postgres  -c  "/usr/lib/postgresql/9.5/bin/initdb  -D /data/postgres/pgsql/data"
su - postgres  -c  "/usr/lib/postgresql/9.5/bin/pg_ctl  -D /data/postgres/pgsql/data -l /tmp/postrest.log start ""



##8. redis 
apt-get  install  redis-server
# redis-cli   -h 10.72.12.234   -p 6379  -a '123456'






