#!/bin/bash
#####contact: sundong306@foxmail.com
########################################


init_centos6 ()  {
###############  CentOS  6  初始化	
##yum
cd  /etc/yum.repos.d  ;  mkdir  backup   ;   cp  *repo  backup
wget  http://mirrors.aliyun.com/repo/Centos-6.repo
wget  http://mirrors.aliyun.com/repo/epel-6.repo
yum clean all 
yum makecache
##history
echo 'export HISTTIMEFORMAT="%F %T ${USER} "' >> /etc/profile
source   /etc/profile
##tool
yum install bind-utils dmidecode dstat fping hdparm iotop ipmitool iptraf psmisc mtr rsync nss bash-completion -y 
yum install lrzsz lsof expect nc nethogs net-tools ntpdate sysstat httpd bc crontabs dos2unix -y 
yum install sos speedtest-cli stat openssh-clients stat tree wget wireshark file jwhois tcpdump -y
##sshd
wget  https://raw.githubusercontent.com/sundong306/conf/master/download/pooks_centos_6_aliyun_sshd_config -O   /etc/ssh/sshd_config
service  sshd  restart
}



init_centos7 ()  {
###############  CentOS  7  初始化	
##yum
cd  /etc/yum.repos.d  ;  mkdir  backup   ;   cp  *repo  backup
wget  http://mirrors.aliyun.com/repo/Centos-7.repo
wget  http://mirrors.aliyun.com/repo/epel-7.repo
yum clean all 
yum makecache
##history
echo 'export HISTTIMEFORMAT="%F %T ${USER} "' >> /etc/profile
source   /etc/profile
##tool
yum install bind-utils dmidecode dstat fping hdparm iotop ipmitool iptraf psmisc mtr rsync nss bash-completion -y 
yum install lrzsz lsof expect nc nethogs net-tools ntpdate sysstat httpd bc crontabs dos2unix -y 
yum install sos speedtest-cli stat openssh-clients stat tree wget wireshark file jwhois tcpdump -y
##sshd
wget  https://raw.githubusercontent.com/sundong306/conf/master/download/pooks_centos_6_aliyun_sshd_config -O   /etc/ssh/sshd_config
service  sshd  restart
}


init_ubuntu ()  {
###############  Ubuntu  初始化
##history
echo 'export HISTTIMEFORMAT="%F %T ${USER} "' >> /etc/profile
source   /etc/profile
## apt
apt install lrzsz lsof expect nethogs net-tools ntpdate sysstat dos2unix  tree wget file tcpdump  dstat   fping  iotop mtr rsync  python-pip   -y
## sshd
wget  https://raw.githubusercontent.com/sundong306/conf/master/download/pooks_ubuntu_16_04_aliyun_sshd_config -O   /etc/ssh/sshd_config
service  ssh  restart
}




#init_centos6
#init_centos7
#init_ubuntu

##swap
Swapon="`swapon -s  | wc  -l`"
if	[ $Swapon   -eq 0  ]
then
dd if=/dev/zero of=/root/swapfile bs=1M count=2048
mkswap /root/swapfile 
swapon /root/swapfile 
echo  "/root/swapfile swap swap defaults 0 0 "  >>  /etc/fstab
free  -m
fi

