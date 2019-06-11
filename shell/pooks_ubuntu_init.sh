#!/bin/bash
#####contact: sundong306@foxmail.com
########################################

###############  ubuntu  12 14 16 18 初始化

##1. 更换到  阿里云 apt 源
#cp  /etc/apt/sources.list  /etc/apt/sources.list.bak
#wget  https://raw.githubusercontent.com/sundong306/conf/master/download/pooks_ubuntu_16_04_aliyun_sources.list  -O  /etc/apt/sources.list


##2. history  加上 时间戳
echo 'export HISTTIMEFORMAT="%F %T ${USER} "' >> /etc/profile
source   /etc/profile


##3. apt 安装基础工具
apt install lrzsz lsof expect nethogs net-tools ntpdate sysstat dos2unix  tree wget file tcpdump  dstat   fping  iotop mtr rsync  python-pip   -y


##4.允许root登录  修改sshd_config   修改ssh端口为 37878/22   
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


