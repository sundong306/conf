#!/bin/bash

#### sundong306@foxmail.com
#### 同步tomcat项目脚本
#### 1.同步指定的文件or目录 2.计数

Succ=0
Failed=0

rsync  -avzP  --password-file=/etc/rsyncd.pwd  --delete  /home/gcweb/usr/local/getipip/webapps/ROOT/   tomcat@139.224.133.198::getipip 
[  $?  = 0 ] && Succ=$[$Succ+1]
[  $? != 0 ] && Failed=$[$Failed+1]


echo "########################################################"
echo -e "Succ:\033[32m$Succ\033[0m\t	Failed:\033[31m$Failed\033[0m"
echo "########################################################"
