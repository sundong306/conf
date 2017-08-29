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
echo 'export HISTFILESIZE=2000' >>/etc/bashrc
echo 'export HISTSIZE=2000' >>/etc/bashrc
echo 'export HISTTIMEFORMAT="%Y%m%d-%H:%M:%S:"' >>/etc/bashrc

#### 3  maxfiles 
echo 'ulimit -u 65535' >> /etc/profile
echo 'ulimit -n 65535' >> /etc/profile
echo 'ulimit -d unlimited' >> /etc/profile
echo 'ulimit -m unlimited' >> /etc/profile
echo 'ulimit -s unlimited' >> /etc/profile
echo 'ulimit -t unlimited' >> /etc/profile
echo 'ulimit -v unlimited' >> /etc/profile
echo 'ulimit -S -c unlimited' >> /etc/profile
echo  "limits.conf update..."
echo '* soft nproc 65535' >> /etc/security/limits.conf
echo '* hard nproc 65535' >> /etc/security/limits.conf
echo '* soft nofile 65535' >> /etc/security/limits.conf
echo '* hard nofile 65535' >> /etc/security/limits.conf
source /etc/profile

#### 4  iptables 
rm  -rf /etc/iptables.sh
cd  /etc/
wget  https://raw.githubusercontent.com/sundong306/conf/master/shell/iptables.sh
chmod  u+x   /etc/iptables.sh
/etc/iptables.sh
echo /etc/iptables.sh >>/etc/rc.local
####  END