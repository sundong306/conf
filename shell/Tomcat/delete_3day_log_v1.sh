#!/bin/bash

#### 每天凌晨2点执行删除/nginx  昨天之前未被修改的日志

find  /nginx/pv   -type f   -ctime +1 -exec rm -f {} \;
find  /usr/local/nginx/logs/    -type f   -ctime +1   -name  "access*" -exec rm -f {} \;

#find  /nginx/pv100   -type f   -ctime +1 -exec rm -f {} \;
#find  /nginx/pvmail  -type f   -ctime +1 -exec rm -f {} \;
