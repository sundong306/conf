#!/bin/bash

####sundong306@foxmail.com
####按日切割 tomcat catalina.out的日志 
####tomcatlogrotata.conf  见附件

/usr/sbin/logrotate -f /etc/tomcatlogrotata.conf >/dev/null 2>&1
EXITVALUE=$?
if [ $EXITVALUE != 0 ]; then
    /usr/bin/logger -t logrotate "ALERT exited abnormally with [$EXITVALUE], execute rotata tomcat log failed"
fi
exit 0
