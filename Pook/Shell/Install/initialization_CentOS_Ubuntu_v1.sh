#!/bin/bash
#####contact: sundong306@foxmail.com
########################################
#
# OS:CentOS   and  Ubuntu  initialization 
#
########################################


##确认是否安装
echo -e "Are you sure  $0 ?(y or n)"
read ANS
if [ "$ANS"a != ya ]
then
   echo -e "bye! \n"
   exit 1
fi


##root
if [ $USER != root ]
then
        echo "only root can run this script!"
        exit 1
fi
##OS
OS=`uname`
[ -f /etc/redhat-release ]  &&   OS=`awk '{print $1}' /etc/redhat-release`             
[ -f /etc/lsb-release ] &&   OS=`head  -1   /etc/lsb-release  |  awk  -F  "="  '{print $2}'`  
[ -f /etc/os-release ]  &&   OS=`head  -1  /etc/os-release   |  awk  -F '[= "]'  '{print $3}'`
case $OS in
        CentOS|Ubuntu)
            echo $OS
            ;;
        *)
			echo  -e "\033[41;34m  Sorry!  Does not support `uname -a` system  \033[0m"
            exit 1
            ;;
    esac


##ok
check_ok () {
if [  $?  != 0 ]
then
echo  -e    "\033[41;34m      ERROR , check the shell log ,  /bin/bash -x   $0  \033[0m" 
exit 1
fi
}

##IP
A=`hostname  -I  |  awk  -F  '.'  '{print $1}'`
B=`hostname  -I  |  awk  -F  '.'  '{print $2}'`
C=`hostname  -I  |  awk  -F  '.'  '{print $3}'`
D=`hostname  -I  |  awk  -F  '.'  '{print $4}'`
echo $A $B $C $D


##sshd
sed  -i  's/Port /#Port /'   /etc/ssh/sshd_config
echo "		"  >>  /etc/ssh/sshd_config
echo "Port 37878 "  >>  /etc/ssh/sshd_config


##hostname
if [ "$OS" == 'CentOS' ]
then
	sed  -i  's/HOSTNAME/#HOSTNAME/'   /etc/sysconfig/network
	echo  "HOSTNAME=Tencent-GZ-$A-$B-$C-$D" >>  /etc/sysconfig/network
	hostname  "Tencent-GZ-$A-$B-$C-$D"
	hostname
else
	>  /etc/hostname
	echo  "Tencent-GZ-$A-$B-$C-$D" > /etc/hostname
	hostname  "Tencent-GZ-$A-$B-$C-$D"
	hostname
fi

##swap
Mem=`free  -m  | grep  Mem  | awk   '{print  $2}'`
Swap=`free -m  | grep  Swap | awk   '{print  $2}'`
if [ $Swap -lt $Mem  ]
then
for  M in  `free | grep  Mem | awk  '{print  $2}'`  ;  do  dd if=/dev/zero of=/home/swap  bs=1024 count=$M  ;  done
mkswap /home/swap
/sbin/swapon /home/swap
check_ok
echo "/home/swap swap swap default 0 0"  >>   /etc/fstab
free  -m
fi 


##utf-8 history
if [ "$OS" == 'CentOS' ]
then
	echo "		"  >> /etc/bashrc
	echo "LANG=zh_CN.UTF-8"  >> /etc/bashrc
	grep --colour "export HISTTIMEFORMAT"  /etc/bashrc
	if [ $? != 0  ]
	then
		echo 'export HISTTIMEFORMAT="%F %T    ${USER} 	"' >> /etc/bashrc
	else 
		sed  -i  's/export HISTTIMEFORMAT/#export HISTTIMEFORMAT/'      /etc/bashrc
		echo 'export HISTTIMEFORMAT="%F %T    ${USER} 	"' >> /etc/bashrc
	fi
	source /etc/bashrc && echo  "source /etc/bashrc  ok"
	check_ok 
else
	locale-gen en_US.UTF-8
	locale-gen zh_CN.UTF-8
	echo "		"  >> /etc/profile
	echo "LANG=zh_CN.UTF-8"  >> /etc/profile
	echo 'export HISTTIMEFORMAT="%F %T    ${USER} 	"' >> /etc/profile
	source /etc/profile  && echo  "source /etc/profile ok"
	check_ok
fi
ls  -l   && echo  "utf-8 history  is ok"

##time
cp   /usr/share/zoneinfo/Asia/Chongqing /etc/localtime
date


##sshd
if [ "$OS" == 'CentOS' ]
then
	service  sshd  restart
	yum install  -y  lsof
	lsof  -i:37878
	check_ok
else
	service ssh restart
	apt-get install  lsof  -y
	lsof -i:37878
	check_ok
fi

#selinux  
setenforce 0


echo   -e  "Succ :\033[32m           $OS Server initialized successfully !   Please exit and sign in again   \033[0m\t"
##end


