#!/bin/bash

#### sundong306@foxmail.com
#### 每天凌晨1点切割nginx日志
#### 判断日志是否大于900k , 判断日志是否已经切割完成
#### 直接用 /usr/local/nginx/sbin/nginx -s reload 重启

## 非root用户无法执行  
if [ $USER != root ]
then
        echo "only root can run this script!"
        exit 1
fi

##判断脚本执行情况
check_ok() {
if [ $? != 0 ]
then
echo "Error, Check the error log."
exit 1
fi
}


##获得大于100k的日志文件名
Date=$(date -d "1 days ago" +"%Y%m%d")
File_name=$(find   /usr/local/nginx/logs/  -size +100k   -name  "access*.log"  |  awk -F  /  '{print $NF}')

##打包， 重命名
for  File_rename in `echo $File_name`
do 
   cd  /usr/local/nginx/logs/
   ###判断日志是否已经切割   
   [ -e  ${File_rename}_${Date}.tar.gz ]  && echo "Error ! ${File_rename}_${Date}.tar.gz  is already exist !"  &&  continue 
   mv  ${File_rename}    ${File_rename}_${Date}
   tar zcf  ${File_rename}_${Date}.tar.gz   ${File_rename}_${Date}
   echo  "$File_rename has been mv ! "
done

##重新加载nginx
sleep  2
/usr/local/nginx/sbin/nginx -t
[ $? = 0  ]  &&  /usr/local/nginx/sbin/nginx  -s reload &&  echo "nginx has been reload "
[ $? != 0 ]  &&   echo "Error ! check ningx  -t ! " 

##将半月前的日志文件压缩包删除
#find  /usr/local/nginx/logs/   -name  "*.tar.gz"   -ctime  +15  -exec  mv  {}  /tmp \;

