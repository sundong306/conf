#!/bin/bash
# david.sun@idreamsky.com
# 2019.05.21
# v1.0  地铁跑酷 正式服 更新
#############   contact: sundong306@foxmail.com
#############   /bin/bash  -x  ld_publish_3jianhao.sh   20180711
echo "++===================================================================================++"
echo "++                       乐逗运维-发布变更-维护工具                                  ++"
echo "++                                                                                   ++"
echo "++                      当前环境【TXY 地铁跑酷  线上环境】    	                  ++"
echo "++===================================================================================++"

##ledou00
if [ $USER != root ]
then
        echo "only root can run this script!"
        exit 1
fi


############# 1.备份all +拉取代码 +  拉维护 + stop crontab
Download_pgk () {
echo  -e   " \n\033[32m 1.备份all +拉取代码  .......... \033[0m "
echo  'do  nothing'
}

#############  2.更新  subwayruncool_yufabu_web
subwayruncool_yufabu_web () {
echo  -e   " \n\033[32m 2.更新 subwayruncool_yufabu_web  .......... \033[0m "
####  代码机   从svn拉取更新文件到 预发布目录
salt  Q-gz-comm-codeOri  cmd.run   runas=alan.lian  "cd /data/svn/alan.lian/subway/subway_test_web ;  svn  sw http://gamesvn.ids111.com:9906/public_version_server/subwaysurfer/program/tags/1-2-2-29/source_code/"
#svn up
#svn sw  http://gamesvn.ids111.com:9906/public_version_server/subwaysurfer/program/tags/1-2-2-28/source_code
####  发布机   从 代码机 拉取更新文件到 预发布目录
######  修改配置文件  （根据tapd需求）
######  cd  /data/www/subway_test_web/app/protected/config
######  该目录下是相关数据库，redis的配置文件的修改
/bin/bash /data/www/script/rsync_from_svnServer_subway.sh subway_test_web

####  推送更新文件到  预发布环境
salt  Q-gz-templerun2-test-web  cmd.run   runas=ledou00  "/bin/bash /data/script/update_subway_test_web.sh"

####  重启worker（根据提单需求判断是否需要执行）
ssh  -f -n  -q  -p  37878  ledou00@10.186.37.116  "cd  /data/game/subway_test_web/cron/    &&  bash  worker.sh restart  &&  ps aux  | grep  ledou00 | grep php | grep  subway_test_web  | head -1 "
sleep 10
echo  -e   " \n\033[32m 修改配置文件  （根据tapd需求）  .......... \033[0m "
echo  -e   " \n\033[32m 预发布更新完成之后 核实 预发布 的 photon 是否被 地铁跑酷使用中， 若不是 ，切  .......... \033[0m " 
}





#############  3.更新  subwayruncool_normal_web
subwayruncool_normal_web () {
echo  -e   " \n\033[32m 3.更新 subwayruncool_normal_web  .......... \033[0m "
#####  拉取更新
cd /data/www/subway_surf_svn
svn info
#svn up
#svn sw  http://gamesvn.ids111.com:9906/public_version_server/subwaysurfer/program/tags/1-2-2-29/source_code/


##### 修改配置文件 （根据提单需求判断是否需要执行） 目录下是相关数据库，redis的配置文件的修改
#cd /data/www/subway_surf_svn/app/protected/config

#####  同步
cat /data/ld_fabu/conf/Q-gz-subway-web.txt |  grep -v "^#\|^$" | while read IP
do
echo $IP 
/usr/bin/rsync -azP --itemize-changes     /data/www/subway_surf_svn/   -e 'ssh -p 37878' root@${IP}:/data/www/subway_surf/
done

echo  -e   " \n\033[32m 修改配置文件  （根据tapd需求）  .......... \033[0m "
}




#############  4.更新  subwayruncool_normal_pvp
subwayruncool_normal_pvp () {
echo  -e   " \n\033[32m 4.更新 subwayruncool_normal_pvp  .......... \033[0m "
cd /data/www/subway_pvp_svn
svn info
#svn up
#svn sw  http://gamesvn.ids111.com:9906/public_version_server/subwaysurfer/program/tags/1-2-2-29/source_code/

##### 修改配置文件 （根据提单需求判断是否需要执行） 目录下是相关数据库，redis的配置文件的修改
#cd /data/www/subway_pvp_svn/app/protected/config

#####  同步

cat /data/ld_fabu/conf/Q-gz-subway-pvp.txt |  grep -v "^#\|^$" | while read IP
do
echo $IP 
/usr/bin/rsync -azP --itemize-changes     /data/www/subway_pvp_svn/   -e 'ssh -p 37878' root@${IP}:/data/www/subway_pvp_web/
done
echo  -e   " \n\033[32m 修改配置文件  （根据tapd需求）  .......... \033[0m "
}




############# 5 地铁跑酷  正式环境worker重启
subwayruncool_restart_worker () {
echo  -e   " \n\033[32m 5.重启 subwayruncool_restart_worker  .......... \033[0m "
### subway-pvp-web-1 subway-pvp-web-2  subway-pvp-web-3
ssh  -f -n  -q   -p  37878  root@10.104.250.160  "cd /data/www/subway_pvp_web/cron/ &&  ./worker.sh restart  ;  ps aux  | grep  root| grep  php | grep subway_pvp_web | head  -1"
ssh  -f -n  -q    -p  37878  root@10.104.32.120   "cd /data/www/subway_surf/cron/    && ./worker.sh restart   ;  ps aux  | grep  root| grep  php | grep subway_surf | head  -1"
ssh  -f -n  -q    -p  37878  root@10.104.50.33    "cd /data/www/subway_surf/cron/ 	  && ./worker.sh restart   ;  ps aux  | grep  root| grep  php | grep subway_surf| head  -1"
sleep  20
}






###### Last:更新操作提示语
Fun_List(){
echo 
cat << EOF
请选择操作:
##TXY 地铁跑酷  线上环境更新#
s1：地铁跑酷  操作预留
s2: 地铁跑酷  预发布环境    更新
s3: 地铁跑酷  正式环境 web  更新
s4: 地铁跑酷  正式环境 pvp  更新
s5: 地铁跑酷  正式环境worker重启



q: 退出
EOF


echo ""
echo "注意：【文件需要准备好，各操作步骤需要顺序执行】"
echo ""
read -p "请选操作项 :>" OPTION
case "$OPTION" in
    s1|Download_pgk)
         echo -e "[`date`] 备份all +拉取代码  \n"  
         Download_pgk
         Fun_List;
         ;;
    s2|subwayruncool_yufabu_web)
	 echo -e "[`date`] subwayruncool_yufabu_web \n" 
	     subwayruncool_yufabu_web
         Fun_List;
         ;;
    s3|subwayruncool_normal_web)
	 echo -e "[`date`] subwayruncool_normal_web \n" 
	     subwayruncool_normal_web
         Fun_List;
         ;;
    s4|subwayruncool_normal_pvp)
	 echo -e "[`date`] subwayruncool_normal_pvp \n" 
	     subwayruncool_normal_pvp
         Fun_List;
         ;;
    s5|subwayruncool_restart_worker)
         echo -e "[`date`] subwayruncool_restart_worker  \n"  
         subwayruncool_restart_worker
         Fun_List;
         ;;
    Q|q|quit|exit)
	 echo -e "[`date`] exit \n" 
         echo "Thank you!"
         ;;
    ""|*)
        Fun_List
        ;;
    esac
} 

Fun_List
