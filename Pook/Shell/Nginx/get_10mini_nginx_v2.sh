#!/bin/bash

#### sundong306@foxmail.com
#### 脚本功能:每隔10mini 截取一次nginx access log
#### 凌晨1点左右不执行此脚本 执行日志切割脚本ing
#### 是否发送邮件:1 发   ; 0 不发
Send_mail=1


####定义一些全局变量
Ip_addr=`/sbin/ifconfig  | grep  inet | head  -1 | awk   '{print $2}'  | awk  -F '.'  '{print $NF}'`
Host_name=`hostname -I`
Date=`date +%Y%m%d`
Date_year=`date +%F`
Date_yes=`date -d "1 days ago" +%Y%m%d`
Date_mini=`date +%Y%m%d_%H%M`
Date_yes_mini=`date -d '1 days ago' +%Y%m%d_%H%M`
Date_sencond=`date  +"%F %T"`


####判断是否在凌晨一点左右
Date_1=`date +%H%m`
Date_2=0055
Date_3=0105
[ $Date_1 -gt $Date_2 ] && [ $Date_1 -lt $Date_3 ] && echo "凌晨1点左右执行日志切割脚本ing"  && exit 1


####nginx 项目名称
Project=`find  /usr/local/nginx/logs/   -size +100k  -mtime -1  -name  "access*log"  |  awk  -F  '_'  '{print $NF}' | awk -F  '.'  '{print $1}'`


####截取近十分钟的日志 将它重定向到/nginx/pv/$Tomcat_$Date_mini.log
####方便下次调用 采集不到的一律为初始值
for  Tomcat in  $Project
do

	Line_num="/nginx/line/${Tomcat}_line.tmp"
        cd  /usr/local/nginx/logs/
	[ ! -s  access_$Tomcat.log ] && continue
	cd  /nginx/pv/
        [ ! -s  $Line_num ]  && wc  -l  /usr/local/nginx/logs/access_$Tomcat.log | awk '{print $1}' > $Line_num && continue
	[ -s $Line_num ] && Begin_line=`cat $Line_num`  &&  wc  -l  /usr/local/nginx/logs/access_$Tomcat.log | awk '{print $1}' > $Line_num  && End_line=`cat $Line_num`
	if 	[ $Begin_line -lt $End_line  ]
	then
		sed -n "$Begin_line,$End_line"p /usr/local/nginx/logs/access_$Tomcat.log > /nginx/pv/${Tomcat}_${Date_mini}.log
	elif	[ $Begin_line -gt $End_line  ]
	then
		echo "1"  >  $Line_num  && echo " Error ! Begin_line > End_line "
	else
		echo " Error ! Begin_line = End_line "  &&  continue
	fi


	####分析/nginx/pv/$Tomcat_$Date_mini.log 
	####若pv>50 && url>10  则记录下来 并于昨天的数据进行对比
	Pv_yes_log="/nginx/pv/${Tomcat}_${Date_yes_mini}.log"
	Pv_log="/nginx/pv/${Tomcat}_${Date_mini}.log"
	Pv100_yes_log="/nginx/pv100/${Tomcat}_${Date_yes_mini}.log"
	Pv100_log="/nginx/pv100/${Tomcat}_${Date_mini}.log"
	Pvmail_log="/nginx/pvmail/${Tomcat}_${Date_mini}.log"

	Pv_sum=`wc -l $Pv_log | awk  '{print $1}'`
	[ -z $Pv_sum ] && echo "$Tomcat access log is not exist "  && continue 
	echo "$Date_sencond $Tomcat PV is $Pv_sum "  > $Pvmail_log 
	[ $Pv_sum -lt 50 ]  &&  echo "ignore ! the $Tomcat pv is less then 100 pv ! "  &&   continue
	[ $Pv_sum -ge 50 ]  &&  echo $Pv_sum >>  /nginx/pv100/$Tomcat_$Date_mini.log
	awk  -F  '"|?'  '{print $3}' $Pv_log  | sort | uniq  -c  | sort  -nr  |  awk '$1>=10 {print $0}' | awk  '{print $1,$3}'  >>  $Pv100_log
	[ -s  $Pv_log ] && [ -s  $Pv_yes_log ]  && [    -s  $Pv100_yes_log ]  &&  [ -s $Pv100_log  ] || continue	
	
	####NR==FNR 表示读取第一个文件， NR>FNR 表示读取第二个文件， a[$2]=$1表示将第一个文件里的$1 赋值给数组a[$2] ，
	####$2 in a 依次读取第一个文件的每行,判断第二个文件的$2是否在里面
	####%-40s 格式为左对齐且宽度为40的字符串代替（-表示左对齐），不使用则是右对齐， %-4.2f 格式为左对齐宽度为4，保留两位小数
	cd /nginx/pv100/
	awk 'NR==FNR{a[$2]=$1;next}NR>FNR  {if($2 in a){printf ("%s\t%-40s\t%-5s\t%-40s\tratio:%-.1f\n", $1,$2,a[$2],$2,$1/a[$2])} else{printf ("%s\t%-100s\tratio:%-5s\n",$1,$2,$1)}}'  $Pv100_yes_log  $Pv100_log  >>  $Pvmail_log	


	####发送邮件
	#[ $Send_mail -eq 0 ]   &&  continue
	#[ $Send_mail -eq 1 ]   &&  mail  -s "$Date_year  PV has been  unusual visited   on  $Host_name !"  15000305224@163.com  < $Pvmail_log
	
done
