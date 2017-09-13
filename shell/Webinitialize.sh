#!/bin/bash
##
### only root can run this script.
### CentOS  6
if [ $USER != root ]
then
        echo "only root can run this script!"
        exit 1
fi

#### 1  yum
cd  /etc/yum.repos.d
yum   install   wget   -y
mkdir   backup   ;   mv *.repo  backup/
wget http://mirrors.aliyun.com/repo/Centos-6.repo
wget http://mirrors.aliyun.com/repo/epel-6.repo
yum   clean all   ;   yum  makecache
yum  install  -y    gcc   gcc-c++  make openssl-devel   patch unzip perl  ntp git vixie-cron crontabs
yum  install  -y tree net-tools bind-utils tree sysstat vim-en* lrzsz  iftop tcpdump telnet traceroute

#### 2  history
echo 'export HISTTIMEFORMAT="%F %T `whoami` " ' >> /etc/profile
source /etc/profile


#### 3  maxfiles 
#### http://www.linuxidc.com/Linux/2014-12/110891.htm
echo  "limits.conf update..."
cd  /etc/security/
mv  /etc/security/limits.conf /tmp
wget  https://raw.githubusercontent.com/sundong306/conf/master/shell/limits.conf
chmod  644  /etc/security/limits.conf

#### 4  iptables 
rm  -rf /etc/iptables.sh
cd  /etc/
wget  https://raw.githubusercontent.com/sundong306/conf/master/shell/iptables.sh
chmod  u+x   /etc/iptables.sh
/etc/iptables.sh
echo /etc/iptables.sh >>/etc/rc.local
####  END
