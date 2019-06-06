#!/bin/bash



序号	命令	命令安装	命令功能	命令参数	命令实例
1	ab	yum  install httpd  	web压力测试	kcn	ab  -k  -c10 -n20  https://www.getipip.com/gg.html
2	bc	yum  install bc	小数计算	无	echo 'scale=3; 3/2' | bc
3	chage	无	管理密码有效期	无	
4	cp	无	复制文件或者目录	a	cp -a 源 目标
5	crontab	yum  install crontabs	计划任务	无	无
6	date	无	打印时间	无	date  -d  @1487050306  +"%F %T"
7	df	无	磁盘空间使用情况	无	df  -h
8	dig	yum  install bind-utils	查询DNS	无	dig  pook.com MX  +short
9	dmidecode	yum  install dmidecode	获取硬件信息	无	dmidecode | grep 'Product'
10	dstat	yum  install dstat	多功能系统资源统计	无	dstat -a
11	du	无	文件大小	无	du -sh  *
12	ethtool	无	获取网卡状态	无	ethtool  eth0
13	find	无	查找	mtime	find */ -type f -name "bydrqp_game_TC*" -exec cp -a by_server_TT {} \;
					find ./ -name *.sh  -type f -print | xargs  file
14	fping	yum  install fping	主机存活状态	无	fping -g 192.168.1.1/28
15	hdparm	yum  install hdparm	显示与设定硬盘的参数	无	hdparm  /dev/sda
16	history	无	显示曾执行过的命令	无	echo 'export HISTTIMEFORMAT="%F %T `whoami` "  ' >> /etc/profile
17	iftop	yum  install iftop	ip网络流量	i	iftop   -i  eth0
18	iotop	yum  install iotop	监视磁盘io	u	iotop  -u   gcweb
19	ipmitool	yum  install ipmitool	远程管理服务器	无	ipmitool  mc  info
20	iptraf-ng	yum  install iptraf	监视网卡流量	无	iptraf-ng
21	java 	无	运行java进程	无	java [options] -jar filename [args]
22	kill	yum  install psmisc	杀死指定进程	无	killall  zabbix_server
23	ln	无	建立一个同步的链接	s	ln -s 源 目标
24	lrzsz	yum  install  lrzsz	快速上传和下载文件	b	无
25	lsblk	无	列出所有的块设备	无	lsblk
26	lsof	yum  install lsof	列出系统打开文件	puic	lsof |grep  delete
27	mail	无	发邮件	无	mail -s '2016.12.28 Test'   1578980735@qq.com <   page.html
28	mkpasswd	yum  install expect	生成随机密码	无	mkpasswd -l  10 -s 1 -d 2 -c 3  -C 4
29	modprobe	无	增删内核模块	无	modprobe  ipmi_poweroff
31	nc	yum  install nc	Debug分析器	l	nc -vuz 193.112.157.126 22
32	nethogs 	yum  install nethogs 	进程网络流量	无	nethogs eth0
33	netstat	yum  install net-tools	网络相关信息	lnpt	netstat  -alnpt
34	nmap	yum  install nmap	扫描端口	无	nmap -sT 120.77.180.91  系统  nmap  -A  116.211.105.1   nmap  -p   80,433  pooks.cn
35	nohup	yum  install coreutils	后台继续运行相应的进程	无	nohup sh  a1.sh   & 
36	ntpdate	yum  install ntpdate	时间同步	无	ntpdate time.windows.com
37	ping	无	网络连通性	fc	ping -fc 100 202.103.24.68
38	printf	无	输出	无	printf "%x\n" 33541
39	ps	无	显示进程	无	ps aux
40	rpm	无	管理软件包	e	rpm  -ivh  https://repo.nagios.com/nagios/6/nagios-repo-6-2.el6.noarch.rpm
41	sar	yum   install   sysstat	系统性能分析工具	A	sar  -n  DEV
42	scp	无	拷贝文件	Prp	scp -P 22 -rp 8.8.8.3:/tmp/db.sql  /tmp/
43	script	无	记录当前用户的操作记录	无	无
44	smartctl	yum  install smartmontools	磁盘检测	无	smartctl  -a /dev/sda
45	sosreport	yum  install sos	生成系统诊断报告	无	sosreport
46	speedtest-cli	pip  install speedtest-cli	测上下行带宽	无	speedtest-cli
47	ss	无	获取socket统计信息	as	ss -a
48	ssh	yum  install  openssh-clients	远程登录	p	 ssh    127.0.0.1  -p  63522
49	ssh-keygen	无	生成、管理和转换认证密钥	无	ssh-keygen  -R  116.211.105.10
50	stat	yum  install stat 	获取文件的属性	无	无
52	sysctl	无	调整linux内核参数	无	sysctl -w net.ipv4.icmp_echo_ignore_all=1
53	tree	yum  install tree  	显示磁盘目录结构	无	tree  -L  2  -d
54	useradd	无	创建用户	无	useradd -d /home/wwwroot -s /sbin/nologin ftp
55	vmstat	无	系统状态	无	无
56	watch	无	定时执行命令	无	watch -n 10 iostat
57	wget	yum  install wget 	下载文件	P	无
58	wireshark	yum  install wireshark	抓包	无	tshark -i eth0 port 80
59	xtrabackup	yum  install percona-xtrabackup	热备	无	无
60	rename	无	批量重命名	无	rename  sd  rewrite  sd*
61	read	无	标准输入读取数据	无	read -t 30 -p "please input your name: " name
62	enca	无	查看并转换文件的编码	无	enca -L zh_CN   -x UTF-8  nginx.conf 
63	usermod	无	修改sodu权限	无	usermod -aG sudo aoa_cp
64	select-editor	无	选择默认编辑器	无	无
65	dos2unix	yum install dos2unix	转化为unix	无	dos2unix   login_jd.py
66	file	yum install file	查看文件类型	无	file  login_jd.py
67	timedatectl		没装NTP每次改了时间又被同步回网络时间去了	无	timedatectl  set-ntp  no
68	tr	无	从标准输入中替换、缩减和/或删除字符，并将结果写到标准输出	无	tr  -s  "\n" ","   <  3.txt  删除换行
69	hostnamectl 	无	永久修改主机名  避免大写变小写	无	hostnamectl --static set-hostname <host-name>


mkdir   /data/app   ;  cd   /data/app


# 1. SendEmail
wget http://caspian.dotconf.net/menu/Software/SendEmail/sendEmail-v1.56.tar.gz 
tar -xzvf sendEmail-v1.56.tar.gz 
cd sendEmail-v1.56 
mv sendEmail /usr/local/bin/
/usr/local/bin/sendEmail -f "15000305224@163.com" -s "smtp.163.com" -xu "15000305224" -xp "mima" -u "2017.04.07" -m "Nagios alert " -t "18062069926@163.com" 



# 2.
