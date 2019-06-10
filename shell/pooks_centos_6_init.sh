#!/bin/bash


###############  CentOS  6  初始化

##1. 更换到  阿里云 yum 源
cd  /etc/yum.repos.d  ;  mkdir  backup   ;   cp  *repo  backup
wget  http://mirrors.aliyun.com/repo/Centos-6.repo
wget  http://mirrors.aliyun.com/repo/epel-6.repo
yum clean all 
yum makecache


##2. history  加上 时间戳
echo 'export HISTTIMEFORMAT="%F %T ${USER} "' >> /etc/profile
source   /etc/profile


##3. apt 安装基础工具
yum install bind-utils dmidecode dstat fping hdparm iotop ipmitool iptraf psmisc mtr rsync nss bash-completion -y 
yum install lrzsz lsof expect nc nethogs net-tools ntpdate sysstat httpd bc crontabs dos2unix -y 
yum install sos speedtest-cli stat openssh-clients stat tree wget wireshark file jwhois tcpdump -y

##4.修改ssh端口为 37878   允许root登录  修改sshd_config  
wget  https://raw.githubusercontent.com/sundong306/conf/master/download/pooks_centos_6_aliyun_sshd_config -O   /etc/ssh/sshd_config


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



