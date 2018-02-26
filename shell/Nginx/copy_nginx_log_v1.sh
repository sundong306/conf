#!/bin/bash
###sundong306@foxmail.com
###截取nginx日志  明确日志的起点和终点  然后用sed 截出来
###nginx 日志格式 通过log_format控制
###140.205.201.43"[07/Feb/2017:11:36:52 +0800]"GET /rs-status HTTP/1.1"404"969"http://zabbix.getipip.com/"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;Alibaba.Security.Heimdall.5108630)"-"0.005"120.77.180.91:8080"zabbix.getipip.com"-
###可能某分钟没有日志，可以模糊匹配 选择小时截取
###执行脚本格式
###./cut_nginx_log_v1.sh  cacti  0204_0900 0204_1355
###./cut_nginx_log_v1.sh  cacti  0204_0900


#Ip_addr=`hostname -I | awk -F '.'  '{print $NF}'`
Ip_addr=`ifconfig | grep "inet" | head -1 | awk '{print $2}'| awk -F'.' '{print $NF}'`
Log_file="/usr/local/nginx/logs/access_$1.log"
Date=`date +%Y%m%d%H%M`
Nginx=$1
Year=`date +%Y`

###时间格式 格式化 07/Feb/2017:11:36
Begin=$2
Begin_1=`echo ${Begin:0:2}`
Begin_2=`echo ${Begin:2:2}`
Begin_3=`echo ${Begin:5:2}`
Begin_4=`echo ${Begin:7:2}`
Begin_time="${Year}-${Begin_1}-${Begin_2} ${Begin_3}:${Begin_4}"
Format_begin=`date -d "${Begin_time}" +"%d/%h/%Y:%H:%M"`


End=$3
if [ ! -z ${End} ]
then
End=$3
End_1=`echo ${End:0:2}`
End_2=`echo ${End:2:2}`
End_3=`echo ${End:5:2}`
End_4=`echo ${End:7:2}`
End_time="${Year}-${End_1}-${End_2} ${End_3}:${End_4}"
Format_end=`date -d "${End_time}" +"%d/%h/%Y:%H:%M"`
else 
Format_end=${Year}
fi

check_ok () {
	if [ $? != 0 ]
	then
                        echo  -e   "\033[31mInput error  ..........       sh -x $0        ........... Input error   \033[0m"
                        echo  -e   "\033[31mInput error  ..........       sh -x $0        ........... Input error   \033[0m"
                        echo  -e   "\033[31mInput error  ..........       sh -x $0        ........... Input error   \033[0m"
                        echo  -e   "\033[31mInput error  ..........       sh -x $0        ........... Input error   \033[0m"
	exit 1
	fi
}


check_nginx () {
	if [ ! -e  ${Log_file} ]
	then
	echo "Error, Check the nginx log  is not exist ! "
	echo "you can choose:"
	find    /usr/local/nginx/logs/  -type f  -size +10k -name  "access_*log"  |  awk -F '[_.]'  '{print $(NF-1)}'
	exit 1
	fi
}


case "$#" in 
    0)
	echo "usage: $0  nginx  {begin_time|begin_time end_time}"
	exit 1
	;;
    1)
	check_nginx $#
	echo "usage: $0 nginx  {begin_time|begin_time end_time}"
	exit 1
	;;
    2)
	check_nginx $#
        Begin_line=`grep  -n "${Format_begin}"  ${Log_file}   | head  -1 |  awk -F ':'  '{print $1}'`
        [ -z ${Begin_line} ] &&  echo "Error, Check the Begin_line" && exit 1
        sed  -n  "${Begin_line},$"p  ${Log_file}  > /tmp/${Ip_addr}_${Nginx}_${Date}.log
        check_ok
        cd /tmp
        tar zcf  ${Ip_addr}_${Nginx}_${Date}.tar.gz  ${Ip_addr}_${Nginx}_${Date}.log
        rm  -rf  ${Ip_addr}_${Nginx}_${Date}.log
	echo "Success to get nginx logs."
	sz  ${Ip_addr}_${Nginx}_${Date}.tar.gz
	;;
    3)
	check_nginx $#
	Begin_line=`grep  -n "${Format_begin}"  ${Log_file}   | head  -1 |  awk -F ':'  '{print $1}'`
	[ -z ${Begin_line} ] && echo "Error, Check the Begin_line"  && exit 1
        End_line=`grep  -n "${Format_end}"  ${Log_file}   | tail  -1 |  awk -F ':'  '{print $1}'`
        [ -z ${End_line} ]   && echo "Error, Check the End_line"    && exit 1
	sed  -n  "${Begin_line},${End_line}"p  ${Log_file}  > /tmp/${Ip_addr}_${Nginx}_${Date}.log
	check_ok
	cd /tmp
	tar zcf  ${Ip_addr}_${Nginx}_${Date}.tar.gz  ${Ip_addr}_${Nginx}_${Date}.log
	rm  -rf  ${Ip_addr}_${Nginx}_${Date}.log
        echo "Success to get nginx logs."
        sz  ${Ip_addr}_${Nginx}_${Date}.tar.gz
	;;
    *)
	echo "usage: $0  nginx  {begin_time|begin_time end_time};你使用的参数太多哦."
	;;
esac

