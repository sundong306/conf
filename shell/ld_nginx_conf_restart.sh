#!/bin/bash
# david.sun@idreamsky.com
# 2019.05.21
# v1.0  神庙逃亡2 正式服 更新
#############   contact: sundong306@foxmail.com
#############   /bin/bash  -x  ld_publish_3jianhao.sh   20180711
echo "++===================================================================================++"
echo "++                       乐逗运维-发布变更-维护工具                                  ++"
echo "++                                                                                   ++"
echo "++                      当前环境【TXY 神庙逃亡2  + 地铁跑酷  nginx 线上环境】                             ++"
echo "++===================================================================================++"

##ledou00
if [ $USER != root ]
then
        echo "only root can run this script!"
        exit 1
fi



############# 1.更新神庙逃亡2  + 地铁跑酷  正式环境   web   pvp   hongbao  nginx



####神庙逃亡2   正式环境   web   pvp   hongbao
cat  /data/ld_fabu/conf/templerun.txt | while read Hostname ;  do salt ${Hostname} cp.get_file salt://subway/nginx/nginx.conf  /data/app/nginx/conf/nginx.conf ; done
#web
for N in  `seq 1 9`  ; do   salt  Q-gz-templerun2-WEB-$N  cp.get_file salt://subway/templerun/360.templerun.uu.cc.conf   /data/app/nginx/conf/conf.d/360.templerun.uu.cc.conf ; done
#pvp
for N in  `seq 11 14`  ; do   salt  Q-gz-templerun2-WEB-$N  cp.get_file salt://subway/templerun/pvp-web-templerun.gxpan.cn.conf   /data/app/nginx/conf/conf.d/pvp-web-templerun.gxpan.cn.conf ; done


cat /data/ld_fabu/conf/templerun.txt | while read Hostname ;  do  salt ${Hostname} cmd.run "/data/app/nginx/sbin/nginx -t   " ; done
cat /data/ld_fabu/conf/templerun.txt | while read Hostname ;  do  salt ${Hostname} cmd.run "/data/app/nginx/sbin/nginx -s  reload " ; done
cat /data/ld_fabu/conf/templerun.txt | while read Hostname ;  do  salt ${Hostname} cmd.run "wc  -l  /data/log/nginx/error.log" ; done



####地铁跑酷  正式环境   web   pvp   hongbao
cat  /data/ld_fabu/conf/subway.txt    | while read Hostname ;  do salt ${Hostname} cp.get_file salt://subway/nginx/nginx.conf  /data/app/nginx/conf/nginx.conf ; done
#hongbao
grep HongBao /data/ld_fabu/conf/subway.txt | while read Hostname ; do salt ${Hostname} cp.get_file salt://subway/nginx/coupon.gxpan.cn.conf /data/app/nginx/conf/conf.d/coupon.gxpan.cn.conf ; done
#pvp
grep pvp /data/ld_fabu/conf/subway.txt | while read Hostname ; do salt ${Hostname} cp.get_file salt://subway/nginx/pvp-web-subway.gxpan.cn.conf   /data/app/nginx/conf/conf.d/pvp-web-subway.gxpan.cn.conf ; done
#web
grep  -v   -E  "pvp|HongBao" /data/ld_fabu/conf/subway.txt | while read Hostname ; do  salt ${Hostname} cp.get_file salt://subway/nginx/game.subway.uu.cc.conf   /data/app/nginx/conf/conf.d/game.subway.uu.cc.conf ; done


cat  /data/ld_fabu/conf/subway.txt | while read Hostname ;  do  salt ${Hostname} cmd.run "/data/app/nginx/sbin/nginx -t   " ; done
cat  /data/ld_fabu/conf/subway.txt | while read Hostname ;  do  salt ${Hostname} cmd.run "/data/app/nginx/sbin/nginx -s  reload " ; done
cat /data/ld_fabu/conf/subway.txt  | while read Hostname ;  do  salt ${Hostname} cmd.run "wc  -l  /data/log/nginx/error.log" ; done
