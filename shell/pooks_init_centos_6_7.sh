#!/bin/bash
# 2020.1.10
# david.sun
# sundong@pooks.cn
# function :  init  centos 6    +  centos 7

Date1=`date +'%F-%H-%M'`
##
if [ $# != 0 ]
then
echo -e "\033[41;34m ERROR , check the shell log , bash -x $0 Tag \033[0m" 
exit 0
fi

# 检查运行人身份信息
if [ "$USER" != root ];then
        echo "当前用户 $(whoami) 不是管理员账身份，请使用管理员身份运行"
        exit 1
fi
echo "nameserver 223.6.6.6" > /etc/resolv.conf


# 初始化 : 检查网络,定义初始化变量
if ping -c2 baidu.com &>/dev/null ;then
        echo "正在初始化程序... ..."
        
        ULIMIT=`ulimit -n`
        A=`hostname  -I |  awk  -F  '.'  '{print $1}'`
        B=`hostname  -I |  awk  -F  '.'  '{print $2}'`
        C=`hostname  -I |  awk  -F  '.'  '{print $3}'`
        D=`hostname  -I |  awk  -F  '.'  '{print $4}'`
        IP=$A-$B-$C-$D
        OS_VERSION=`cat /etc/system-release | awk '{print $(NF-1)}' | awk -F"." '{print $1}' `
else
        echo "检查网络！"
        exit 2
fi

# 修改主机名称
echo "修改主机名称  例如Q-gz-subway-web-1 "
Hostname=Q-gz-${IP}
if [ "$OS_VERSION" -eq 7 ];then
        hostnamectl  --static set-hostname  ${Hostname}
        echo  "127.0.0.1  `hostname`"  >   /etc/hosts
else
        echo -e "NETWORKING=yes\nHOSTNAME=${Hostname}" >/etc/sysconfig/network
fi

# 初始化磁盘
echo "初始化磁盘 "
mkfs.ext4 /dev/vdb
mount /dev/vdb /data
echo "/dev/vdb        /data          ext4    defaults     0 0" >>/etc/fstab   
df -h

# 配置网络yum源
echo "配置网络yum源"
if [[ "$OS_VERSION" =~ [76] ]];then
    mkdir -p /etc/yum.repos.d/${Date1}
    mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/${Date1}/
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-${OS_VERSION}.repo
	sed -i "/aliyuncs/d" /var/www/html/CentOS-${OS_VERSION}.repo
	yum install -y epel-release
	yum clean all
	yum makecache
else
        echo "不支持更改当前系统yum源"
fi

# 安装组件
yum install psmisc gc gcc-c++  telnet  unzip vim curl  zip unzip -y  &>/dev/null
yum install lrzsz lsof   sysstat dos2unix tree wget file tcpdump dstat fping iotop mtr rsync   expect  -y &>/dev/null
if [ "$OS_VERSION" -ne 7 ];then
        yum -y install bash-completion
fi

# 修改系统字符集
echo "修改系统字符集"
if [ "$LANG" == zh_CN.UTF-8 ];then
        if [ "$OS_VERSION" -ne 7 ];then
                echo LANG=\"zh_CN.UTF-8\" >/etc/locale.conf
        elif [ "$OS_VERSION" -ne 6 ];then
                echo LANG=\"zh_CN.UTF-8\" >/etc/sysconfig/i18n
        else
                echo "不支持当前操作系统修改字符集"
        fi
else
        echo "当前系统字符集已是zh_CN.UTF-8，无需修改"
fi


# 关闭防火墙
echo "关闭防火墙"
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0
if [ "$OS_VERSION" -eq 7 ];then
        systemctl stop firewalld.service
        systemctl disable firewalld.service
else
        servcie iptables stop
        chkconfig iptables off
fi

# 配置sshd配置文件
echo "修改ssh默认端口  37878  sshd_config"
cp /etc/ssh/sshd_config /etc/ssh/sshd.${Date1}
#sed -i 's/#Port 22/Port '$PORT'/g' /etc/ssh/sshd_config
sed -i 's/#Port 22/Port 37878/g' /etc/ssh/sshd_config
sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i "s/GSSAPIAuthentication yes/GSSAPIAuthentication no/g" /etc/ssh/sshd_config
if [ "$OS_VERSION" -eq 7 ];then
        systemctl restart sshd
else
        service sshd restart
fi



# 创建用户
echo "创建用户 david.sun"
useradd   -m  david.sun    -s /bin/bash
echo "david.sun:david.sun@2019" | chpasswd 
echo 'david.sun ALL=(ALL) ALL'>> /etc/sudoers
visudo -c

# 修改limits.conf  sysctl.conf core
echo "修改limits.conf  sysctl.conf  core"
wget  https://github.com/sundong306/conf/raw/master/download/ledou_sysctl.conf  -O  /etc/sysctl.conf 
wget  https://github.com/sundong306/conf/raw/master/download/ledou_limits.conf  -O  /etc/security/limits.conf
source   /etc/sysctl.conf
sysctl -p
mkdir  -p   /data/corefile/
chmod  -R  777   /data/corefile/
echo "/data/corefile/core_%e_%p"  > /proc/sys/kernel/core_pattern

# history
wget  https://github.com/sundong306/conf/raw/master/download/ledou_profile  -O  /etc/profile 
source   /etc/profile 


# 休眠3秒重启系统
#echo "已完成初始化系统，3秒后将重启系统... ..."
#sleep 3
#reboot


