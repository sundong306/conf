#!/bin/bash
#### sundong306@foxmail.com
#### 脚本功能： 重启tomcat
#### shutdown.sh  有时不能完全杀死tomcat进程 
#### http://blog.csdn.net/u012599988/article/details/44458083 
#### 需要通过kill  -9  PID 杀死它
#### 思路 先 kill  然后 start
#### 为了安全 禁止使用root用户启动tomcat进程
#### 删除work目录的目的:http://bbs.csdn.net/topics/270057171


Dir_tomcat="/home/gcweb/usr/local/$1"
Dir_logs="/home/gcweb/usr/local/$1/logs"
Date_mini=`date +"%Y%m%d%H%M%S"`

#### 1.禁止root启动tomcat  2.不能多人同时重启同一个tomcat 3.参数需要存在 4.tomcat需要存在
[ $USER = root ]  && echo "root cann't run this script!please run with other user!"  && exit 1
#### 使用赋值会多fork出一个进程
Count=`ps  ux  |  grep  "$0" |  grep  $1  | wc  -l`
[ $Count -gt 2 ] &&  echo "An other process already running ,exit now!"  && exit 1
[ $# -ne 1 ] &&  echo "Usage:$0 tomcatname" &&  exit 1
[ ! -d ${Dir_tomcat} ] &&  echo "Error, Check !  the $1 is not exist !" &&  exit 1


####提示是否确认重启  
echo -e "are you sure restart $1  ?(y or n)"
read Answer
if [ "$Answer" != y ]
then
   echo -e "bye!  do not restart the tomcat $1  !\n"
   exit 1
fi

####stop tomcat
echo "stop tomcat ..."
ps   ux  | grep  java |   grep  $1  | awk  '{print  $2}' | while read PID
do
	kill  -9  $PID
done

echo "start tomcat ..."


sleep 2
rm  -rf   /home/gcweb/usr/local/$1/work/Catalina/*
mv  ${Dir_logs}/catalina.out   ${Dir_logs}/catalina.out_${Date_mini}
sleep 2
/home/gcweb/usr/local/$1/bin/startup.sh
tail  -f  ${Dir_logs}/catalina.out
sleep 10
ps   ux  | grep  tail  | awk  '{print  $2}' | while read PID
do
        kill  -9  $PID
done
# end


