#!/bin/bash
#####contact: sundong306@foxmail.com
########################################
#
# OS:CentOS  7  and  Ubuntu 16   install LNMP+tomcat+redis 
#
########################################
##版本信息如下  对应目录
##mysql 5.7.18 	/data/app/mysql
##nginx 1.12.2	/data/app/nginx
##php   7.2.4	/data/app/php
##redis 3.0.3	/data/app/redis
##JDK   1.8.171 /opt/jdk1.8.0_171/
##tomcat8.5.30	/data/app/tomcat

##确认是否安装
#echo -e "Are you sure  $0 ?(y or n)"
#read ANS
#if [ "$ANS"a != ya ]
#then
#   echo -e "bye! \n"
#   exit 1
#fi

##root
if [ $USER != root ]
then
        echo "only root can run this script!"
        exit 1
fi

##ok
check_ok () {
if [  $?  != 0 ]
then
echo  -e    "\033[41;34m      ERROR , check the shell log ,  /bin/bash -x   $0  \033[0m" 
exit 1
fi
}

##OS
OS=`uname`
[ -f /etc/redhat-release ]  &&   OS=`awk '{print $1}' /etc/redhat-release`             
[ -f /etc/lsb-release ] &&   OS=`head  -1   /etc/lsb-release  |  awk  -F  "="  '{print $2}'`  
[ -f /etc/os-release ]  &&   OS=`head  -1  /etc/os-release   |  awk  -F '[= "]'  '{print $3}'`
case $OS in
        CentOS)
            echo $OS
			yum install -y  make  cmake bison-devel  ncurses-devel   bison 
			yum install -y  pcre*  zlib*   openssl  openssl-devel  libxml*  libxslt*   gd-devel  curl
			yum install -y  git lsof  GeoIP GeoIP-data GeoIP-devel  perl-devel perl-ExtUtils-Embed  
			yum install -y  gcc gcc-c++ libxml2 libxml2-devel bzip2 bzip2-devel libmcrypt libmcrypt-devel libtidy libtidy-devel  mcrypt mhash 
			yum install -y  libcurl-devel libjpeg-devel libpng-devel freetype-devel readline readline-devel libxslt-devel perl perl-devel psmisc.x86_64 recode recode-devel  
			;;
        Ubuntu)
            echo $OS
			apt-get update     ; sleep 10  
			apt-get upgrade -y ; sleep 10 
			apt-get install -y  make  cmake bzip2  mcrypt   recode libncurses5-dev  geoip-database geoip-database-extra libgeoip-dev
			apt-get install -y  git lsof  libgd2-xpm-dev zlib1g-dev libicu-dev build-essential  libcurl4-gnutls-dev libjpeg-dev libpng-dev  
			apt-get install -y  libxslt1-dev libxml2-dev libbz2-dev libcurl4-gnutls-dev libmcrypt-dev libmcrypt4   libmagickwand-dev unzip  
			apt-get install -y build-essential libssl-dev   libreadline-dev libncurses5-dev libpcre3-dev openssl libgd2-xpm-dev libgeoip-dev   
			apt-get install -y libssl-dev  libgd2-xpm-dev libgeoip-dev tofrodos libpam0g-dev perl libperl-dev  libpcre3 libpcre3-dev graphviz
			apt-get install -y autoconf  libtool bison re2c   curl wget libjpeg-dev automake libmagickwand-dev  gcc g++  libpcre3 libpcre3-dev 
			apt-get install -y libpng-dev  libreadline6 libreadline6-dev libgmp-dev libgmp3-dev libxml2  libxml2-dev libbz2-dev  libmcrypt4 
		     ;;			
        *)
			echo  -e "\033[41;34m  Sorry!  Does not support `uname -a` system  \033[0m"
            exit 1
            ;;
    esac

	
IP=`curl -s  ip.sb | awk '{print $1}'`


##1.下载依赖包 和 安装包

cd /opt
wget  https://cdn.mysql.com//archives/mysql-5.7/mysql-boost-5.7.18.tar.gz
wget  http://nginx.org/download/nginx-1.12.2.tar.gz
wget  http://cn2.php.net/distributions/php-7.2.4.tar.gz
wget  http://download.redis.io/releases/redis-3.0.3.tar.gz
#wget -O jdk-8u161-linux-x64.tar.gz --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-x64.tar.gz
wget  https://pooks.cn/download/jdk-8u171-linux-x64.tar.gz
wget  https://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-8/v8.5.30/bin/apache-tomcat-8.5.30.tar.gz
tar   zxf	mysql-boost-5.7.18.tar.gz
tar   zxf	nginx-1.12.2.tar.gz  
tar   zxf	php-7.2.4.tar.gz
tar   zxf	redis-3.0.3.tar.gz
tar   zxf	apache-tomcat-8.5.30.tar.gz 
tar   zxf	jdk-8u171-linux-x64.tar.gz
check_ok
##
groupadd -r mysql && useradd -r -g mysql -s /sbin/nologin -M mysql
groupadd -r www-data && useradd -r -g www-data -s /sbin/nologin -M www-data
mkdir -p /data/app/mysql
mkdir -p /data/app/nginx
mkdir -p /data/app/php
mkdir -p /data/logslow/
chown  -R  mysql.mysql  /data/logslow/

echo   -e  "Succ :\033[32m     1. all  packets  has download !    \033[0m\t"




###2.安装MYSQL 5.7
echo   -e  "\033[32m     2.   开始安装MYSQL ，预计用时十分钟左右    \033[0m\t" 
## https://www.cnblogs.com/goozgk/p/5645041.html
cd /opt/mysql-5.7.18
rm -rf     /opt/mysql-5.7.18/CMakeCache.txt
cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_DATADIR=/data/app/mysql -DWITH_BOOST=boost  -DSYSCONFDIR=/etc -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_PARTITION_STORAGE_ENGINE=1 -DWITH_FEDERATED_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DWITH_MEMORY_STORAGE_ENGINE=1 -DWITH_MYISAM_STORAGE_ENGINE=1 -DENABLED_LOCAL_INFILE=1 -DENABLE_DTRACE=0 -DDEFAULT_CHARSET=utf8mb4 -DDEFAULT_COLLATION=utf8mb4_general_ci -DWITH_EMBEDDED_SERVER=1

check_ok
make -j `grep processor /proc/cpuinfo | wc -l`   &&   make install  && check_ok

ls -lrt /usr/local/mysql
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
chmod +x /etc/init.d/mysqld
echo -e '\n\nexport PATH=/usr/local/mysql/bin:$PATH\n' >> /etc/profile && source /etc/profile
rm -rf  /etc/my.cnf  
rm -rf   /data/app/mysql/*
wget  https://raw.githubusercontent.com/sundong306/conf/master/shell/Install/my.cnf  -P  /etc/
source /etc/profile
mysqld --initialize-insecure --user=mysql --basedir=/usr/local/mysql --datadir=/data/app/mysql
check_ok
systemctl enable mysqld   
systemctl start mysqld
check_ok
systemctl status mysqld
lsof -i:3306  && check_ok
echo   -e  "Succ :\033[32m    2.  MYSQL 5.7  has installed   successfully !    \033[0m\t"



##3.安装PHP  7.2
echo   -e  "\033[32m     3.   开始安装PHP ...........................   \033[0m\t" 
cd /opt/php-7.2.4
./configure  --prefix=/data/app/php --with-config-file-path=/data/app/php/etc --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-mysql-sock=/tmp/mysql.sock --with-libxml-dir --with-gd --with-jpeg-dir --with-png-dir --with-freetype-dir --with-iconv-dir --with-zlib-dir --enable-soap --enable-ftp --enable-mbstring --enable-exif --disable-ipv6 --with-pear --with-curl --with-openssl --enable-zip --enable-pcntl --enable-sysvshm
check_ok
make  &&  make install
check_ok
##
cp  /opt/php-7.2.4/php.ini-production   /data/app/php/etc/php.ini
cp  /data/app/php/etc/php-fpm.conf.default /data/app/php/etc/php-fpm.conf
cp  /data/app/php/etc/php-fpm.d/www.conf.default  /data/app/php/etc/php-fpm.d/www.conf
sed  -i  '/^;/d;/^$/d' /data/app/php/etc/php.ini
sed  -i  '/^;/d;/^$/d' /data/app/php/etc/php-fpm.conf
sed  -i  '/^;/d;/^$/d' /data/app/php/etc/php-fpm.d/www.conf
cp /opt/php-7.2.4/sapi/fpm/php-fpm.service  /lib/systemd/system/php-fpm.service
##
/data/app/php/sbin/php-fpm  -t
systemctl enable php-fpm
systemctl start  php-fpm
systemctl status php-fpm
lsof -i:9000  && check_ok
echo   -e  "Succ :\033[32m    3.  PHP 7.2   has installed   successfully !    \033[0m\t"


###4.安装nginx  1.12
echo   -e  "\033[32m     4.   开始安装NGINX .......................   \033[0m\t"
cd /opt
git clone git://github.com/vozlt/nginx-module-vts.git
wget  https://www.openssl.org/source/openssl-1.0.2g.tar.gz 
tar zxf  openssl-1.0.2g.tar.gz
cd  /opt/openssl-1.0.2g ;  ./config  ; make  &&  make install ; openssl version
check_ok
cd /opt/nginx-1.12.2
./configure   --prefix=/data/app/nginx --user=www-data --group=www-data --with-http_stub_status_module --with-http_ssl_module --with-http_realip_module --with-http_geoip_module --with-stream --with-http_v2_module --with-openssl=/opt/openssl-1.0.2g --add-module=/opt/nginx-module-vts 

check_ok
make  && make  install
check_ok
/data/app/nginx/sbin/nginx  -V
rm -rf  /data/app/nginx/conf/nginx.conf
wget  https://raw.githubusercontent.com/sundong306/conf/master/Dsky/nginx.conf  -P  /data/app/nginx/conf/
/data/app/nginx/sbin/nginx  -t   &&  check_ok
cat > /data/app/nginx/html/index.php<<EOF 
<?php
phpinfo();
?> 
EOF
cat > /lib/systemd/system/nginx.service <<EOF 
[Unit]
Description=nginx
After=network.target
  
[Service]
Type=forking
ExecStart=/data/app/nginx/sbin/nginx
ExecReload=/data/app/nginx/sbin/nginx -s reload
ExecStop=/data/app/nginx/sbin/nginx -s quit
PrivateTmp=true


  
[Install]
WantedBy=multi-user.target
EOF
systemctl enable nginx.service
systemctl start nginx.service
systemctl status  nginx.service
lsof -i:80 && check_ok
echo   -e  "Succ :\033[32m    4.  NGINX 1.12   has installed   successfully !    \033[0m\t"


##5.安装redis 3
echo   -e  "\033[32m     5.   开始安装REDIS .......................   \033[0m\t"
sysctl vm.overcommit_memory=1
sysctl -w net.core.somaxconn=512
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo 'vm.overcommit_memory=1'  >> /etc/sysctl.conf

mv  /opt/redis-3.0.3  /data/app/redis
cd  /data/app/redis
sed  -i  '/^#/d;/^$/d'  /data/app/redis/redis.conf
echo  'bind 127.0.0.1' >>  /data/app/redis/redis.conf
sed  -i  's/daemonize no/daemonize yes/' /data/app/redis/redis.conf
make
check_ok
cat > /lib/systemd/system/redis.service  <<EOF 
[Unit]
Description=The redis-server Process Manager
After=syslog.target network.target

[Service]
Type=forking
PIDFile=/var/run/redis.pid
ExecStart=/data/app/redis/src/redis-server /data/app/redis/redis.conf
ExecReload=/bin/kill -USR2 $MAINPID
ExecStop=/bin/kill -SIGINT $MAINPID

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable redis.service
systemctl start redis.service
systemctl status  redis.service
lsof -i:6379 && check_ok
echo   -e  "Succ :\033[32m    5.  Redis 3.0   has installed   successfully !    \033[0m\t"



##6.安装tomcat 8
echo   -e  "\033[32m     6.   开始安装Tomcat.......................   \033[0m\t"
echo   'export JAVA_HOME=/opt/jdk1.8.0_171/'  >>  /etc/profile
echo   'export CATALINA_BASE=/data/app/tomcat/'  >>  /etc/profile
echo   'export CATALINA_HOME=/data/app/tomcat/'  >>  /etc/profile
echo   'export CLASSPATH=.:$JAVA_HOME/lib'  >> /etc/profile
echo   'export PATH=$PATH:$JAVA_HOME/bin:$CATLINA_HOME:/bin' >> /etc/profile
source /etc/profile
java -version  && check_ok
cp -a   /opt/apache-tomcat-8.5.30    /data/app/tomcat
chown -R www-data.www-data  /data/app/tomcat
cat >  /data/app/tomcat/bin/setenv.sh  <<EOF
JAVA_HOME=/opt/jdk1.8.0_171/
CATALINA_PID="$CATALINA_BASE/tomcat.pid"
JAVA_OPTS="-server -XX:MetaspaceSize=256M -XX:MaxMetaspaceSize=1024m -Xms512M -Xmx1024M -XX:MaxNewSize=256m"
EOF
source /etc/profile
cat > /lib/systemd/system/tomcat.service <<EOF
[Unit]
Description=tomcat
After=syslog.target network.target

[Service]
Type=forking
PIDFile=/data/app/tomcat/tomcat.pid
ExecStart=/data/app/tomcat/bin/startup.sh
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true
User=www-data
Group=www-data

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable tomcat
systemctl start  tomcat
systemctl status tomcat
lsof  -i:8080  && check_ok
echo   -e  "Succ :\033[32m    6.  Tomcat 8    has installed   successfully !    \033[0m\t"


##提示
sleep  10
netstat  -lnpt
chkconfig | grep mysqld
systemctl list-unit-files  | grep  -E  "mysql|php-fpm|nginx|redis|tomcat"

echo   -e  "\033[32m     1.nginx主页请访问  http://${IP}/index.html      \033[0m\t"
echo   -e  "\033[32m     2.PHP info 请访问  http://${IP}/index.php      \033[0m\t"
echo   -e  "\033[32m     3.tomcat主页请访问  http://${IP}:8080   		\033[0m\t"
####END####


