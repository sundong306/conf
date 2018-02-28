#!/bin/bash
###sundong306@foxmail.com
###截取tomcat日志  明确日志的起点和终点  然后用sed 截出来
###tomcat 日志格式 通过log4j.properties控制
###2017-02-04 13:56:09,222 INFO [bydr.manage.core.interceptor.LoginInterceptor] - <login.identity.invalid>
###可能某分钟没有日志，可以模糊匹配 选择小时截取
###执行脚本格式
###./cut_tomcat_log_v1.sh  getipip  0204_0900 0204_1355
###./cut_tomcat_log_v1.sh  getipip  0204_09   0204_13
###./cut_tomcat_log_v1.sh  getipip  0204_0900


#Ip_addr=`hostname -I | awk -F '.'  '{print $NF}'`
Ip_addr=`ifconfig | grep "inet" | head -1 | awk '{print $2}'| awk -F'.' '{print $NF}'`
Log_file="/home/gcweb/usr/local/$1/logs/catalina.out"
Date=`date +%Y%m%d%H%M`
Tomcat=$1


###时间格式 格式化 2017-02-04 13:56
Begin=$2
Begin_1=`echo ${Begin:0:2}`
Begin_2=`echo ${Begin:2:2}`
Begin_3=`echo ${Begin:5:2}`
Begin_4=`echo ${Begin:7:2}`
Begin_time="${Begin_1}-${Begin_2} ${Begin_3}:${Begin_4}"
End=$3
End_1=`echo ${End:0:2}`
End_2=`echo ${End:2:2}`
End_3=`echo ${End:5:2}`
End_4=`echo ${End:7:2}`
End_time="${End_1}-${End_2} ${End_3}:${End_4}"



check_ok () {
	if [ $? != 0 ]
	then
	echo "Error, Check the error log."
	exit 1
	fi
}


check_tomcat () {
	if [ ! -e  ${Log_file} ]
	then
	echo "Error, Check the tomcat is not exist ! "
	echo "you can choose:"
	/bin/ls  /home/gcweb/usr/local/
	exit 1
	fi
}


case "$#" in 
    0)
	echo "usage: $0 tomcat_name {begin_time|begin_time end_time}"
	exit 1
	;;
    1)
	check_tomcat $#
	echo "usage: $0 tomcat_name {begin_time|begin_time end_time}"
	exit 1
	;;
    2)
	check_tomcat $#
        Begin_line=`grep  -n "${Begin_time}"  ${Log_file}   | head  -1 |  awk -F ':'  '{print $1}'`
        [ -z ${Begin_line} ] &&  echo "Error, Check the Begin_line" && exit 1
        sed  -n  "${Begin_line},$"p  ${Log_file}  > /tmp/${Ip_addr}_${Tomcat}_${Date}.log
        check_ok
        cd /tmp
        tar zcf  ${Ip_addr}_${Tomcat}_${Date}.tar.gz  ${Ip_addr}_${Tomcat}_${Date}.log
        rm  -rf  ${Ip_addr}_${Tomcat}_${Date}.log
	echo "Success to get logs."
	sz  ${Ip_addr}_${Tomcat}_${Date}.tar.gz
	;;
    3)
	check_tomcat $#
	Begin_line=`grep  -n "${Begin_time}"  ${Log_file}   | head  -1 |  awk -F ':'  '{print $1}'`
	[ -z ${Begin_line} ] && echo "Error, Check the Begin_line"  && exit 1
        End_line=`grep  -n "${End_time}"  ${Log_file}   | tail  -1 |  awk -F ':'  '{print $1}'`
        [ -z ${End_line} ]   && echo "Error, Check the End_line"    && exit 1
	sed  -n  "${Begin_line},${End_line}"p  ${Log_file}  > /tmp/${Ip_addr}_${Tomcat}_${Date}.log
	check_ok
	cd /tmp
	tar zcf  ${Ip_addr}_${Tomcat}_${Date}.tar.gz  ${Ip_addr}_${Tomcat}_${Date}.log
	rm  -rf  ${Ip_addr}_${Tomcat}_${Date}.log
        echo "Success to get logs."
        sz  ${Ip_addr}_${Tomcat}_${Date}.tar.gz
	;;
    *)
	echo "usage: $0 tomcat_name {begin_time|begin_time end_time};你使用的参数太多哦."
	;;
esac

