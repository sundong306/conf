#!/bin/bash
##
### only root can run this script.
### CentOS  6
if [ $USER != root ]
then
        echo "only root can run this script!"
        exit 1
fi

Release=`awk  '{print $3}'   /etc/redhat-release`
case  "$Release" in
      6.[0-9])
              echo  "Release  is OK !"
              ;;
      *)
          echo "there is no wget-package for this releases."
          exit 1
esac

#### 1  yum
cd  /etc/yum.repos.d
yum   install   wget   -y
mkdir   backup   ;   mv *.repo  backup/
wget http://mirrors.aliyun.com/repo/Centos-6.repo
wget http://mirrors.aliyun.com/repo/epel-6.repo
yum   clean all   ;   yum  makecache
yum  install  -y    gcc   gcc-c++  make openssl-devel   patch unzip perl   git vixie-cron crontabs
yum  install  -y tree net-tools bind-utils tree sysstat vim-en* lrzsz  iftop tcpdump telnet traceroute
yum  install  -y which sed curl mtr virt-what python
echo -e  " 1  yum is ok  \033[32mDone\033[0m" 


#### 2  history
echo 'export HISTTIMEFORMAT="%F %T `whoami` " ' >> /etc/profile
source /etc/profile
echo -e  " 2  history is ok  \033[32mDone\033[0m"


#### 3  maxfiles 
#### http://www.linuxidc.com/Linux/2014-12/110891.htm
echo  "limits.conf update..."
cd  /etc/security/
mv  /etc/security/limits.conf /tmp
wget  https://raw.githubusercontent.com/sundong306/conf/master/shell/limits.conf
chmod  644  /etc/security/limits.conf
echo -e  " 3  maxfiles  is ok  \033[32mDone\033[0m"

#### 4  iptables 
rm  -rf /etc/iptables.sh
cd  /etc/
wget  https://raw.githubusercontent.com/sundong306/conf/master/shell/iptables.sh
chmod  u+x   /etc/iptables.sh
/etc/iptables.sh
echo /etc/iptables.sh >>/etc/rc.local
echo -e  " 4  iptables  is ok  \033[32mDone\033[0m"

#### 5  ntpd
yum   install  -y  ntp && chkconfig ntpd on  && rm -rf  /etc/ntp.conf
cd  /etc  &&  wget https://raw.githubusercontent.com/sundong306/conf/master/shell/ntp.conf 
chmod 644  /etc/ntp.conf  &&  service  ntpd  start  
echo -e  " 5  ntpd is ok  \033[32mDone\033[0m"

####  END
