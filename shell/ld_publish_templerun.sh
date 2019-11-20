#!/bin/bash
# david.sun@idreamsky.com
# 2019.05.21
# v1.0  神庙逃亡2 正式服 更新
#############   contact: sundong306@foxmail.com
#############   /bin/bash  -x  ld_publish_3jianhao.sh   20180711
echo "++===================================================================================++"
echo "++                       乐逗运维-发布变更-维护工具                                  ++"
echo "++                                                                                   ++"
echo "++                      当前环境【TXY 神庙逃亡2  线上环境】    	                  ++"
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

#############  2.更新  templerun2_yufabu_web
templerun2_yufabu_web () {
echo  -e   " \n\033[32m 2.更新 templerun2_yufabu_web  .......... \033[0m "
####  代码机   从svn拉取更新文件到 预发布目录
salt  Q-gz-comm-codeOri  cmd.run   runas=alan.lian  "cd /data/svn/alan.lian/templerun/templerun_test_web ;  svn  up"
#svn up
#svn sw http://svn.ids111.com:81/game_server/templerun_360/backend/program/tags/2.3.8.8
####  发布机   从 代码机 拉取更新文件到 预发布目录
######  修改配置文件  （根据tapd需求）
######  cd  /data/www/subway_test_web/app/protected/config
######  该目录下是相关数据库，redis的配置文件的修改
/bin/bash /data/www/script/rsync_from_svnServer_templerun.sh templerun_test_web

####  推送更新文件到  预发布环境
salt  Q-gz-templerun2-test-web  cmd.run   runas=ledou00  "/bin/bash /data/script/update_templerun_test_web.sh"

####  重启worker（根据提单需求判断是否需要执行）
ssh  -f  -p  37878  ledou00@10.186.37.116  "cd  /data/game/templerun_test_web/cron/    ;  bash  worker.sh restart"
sleep 10
echo  -e   " \n\033[32m 修改配置文件  （根据tapd需求）  .......... \033[0m "
echo  -e   " \n\033[32m 预发布更新完成之后 核实 预发布 的 photon 是否被 神庙逃亡2使用中， 若不是 ，切  .......... \033[0m " 
}





#############  3.更新  templerun2_normal_web
templerun2_normal_web () {
echo  -e   " \n\033[32m 3.更新 templerun2_normal_web  .......... \033[0m "
#####  拉取更新
cd /data/www/templerun_360_svn
svn info
#svn up
#svn sw http://svn.ids111.com:81/game_server/templerun_360/backend/program/tags/2.3.8.8

##### 修改配置文件 （根据提单需求判断是否需要执行） 目录下是相关数据库，redis的配置文件的修改
#cd /data/www/templerun_360_svn/app/protected/config

#####  同步
cat /data/ld_fabu/conf/Q-gz-templerun-web.txt |  grep -v "^#\|^$" | while read IP
do
echo $IP 
/usr/bin/rsync -azP --itemize-changes     /data/www/templerun_360_svn/  -e 'ssh -p 37878' root@${IP}:/data/www/templerun_360/
done

echo  -e   " \n\033[32m 修改配置文件  （根据tapd需求）  .......... \033[0m "
}




#############  4.更新  templerun2_normal_pvp
templerun2_normal_pvp () {
echo  -e   " \n\033[32m 4.更新 templerun2_normal_pvp  .......... \033[0m "
cd /data/www/templerun_pvp_svn 
svn info
#svn up
#svn sw http://svn.ids111.com:81/game_server/templerun_360/backend/program/tags/2.3.8.8

##### 修改配置文件 （根据提单需求判断是否需要执行） 目录下是相关数据库，redis的配置文件的修改
#cd /data/www/templerun_pvp_svn/app/protected/config

#####  同步

cat /data/ld_fabu/conf/Q-gz-templerun-pvp.txt |  grep -v "^#\|^$" | while read IP
do
echo $IP 
/usr/bin/rsync -azP --itemize-changes     /data/www/templerun_pvp_svn/   -e 'ssh -p 37878' root@${IP}:/data/www/templerun_pvp_web/
done
echo  -e   " \n\033[32m 修改配置文件  （根据tapd需求）  .......... \033[0m "
}




############# 5 神庙逃亡2  正式环境worker重启
templerun2_restart_worker () {
echo  -e   " \n\033[32m 5.重启 templerun2_restart_worker  .......... \033[0m "
### templerun2-web-4
ssh  -f  -p  37878  root@10.104.172.49 "cd /data/www/templerun_360/cron   ; ./worker.sh restart"
sleep  10
}






###### Last:更新操作提示语
Fun_List(){
echo 
cat << EOF
请选择操作:
##TXY 神庙逃亡2  线上环境更新#
s1：神庙逃亡2  操作预留
s2: 神庙逃亡2  预发布环境    更新
s3: 神庙逃亡2  正式环境 web  更新
s4: 神庙逃亡2  正式环境 pvp  更新
s5: 神庙逃亡2  正式环境worker重启



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
    s2|templerun2_yufabu_web)
	 echo -e "[`date`] templerun2_yufabu_web \n" 
	     templerun2_yufabu_web
         Fun_List;
         ;;
    s3|templerun2_normal_web)
	 echo -e "[`date`] templerun2_normal_web \n" 
	     templerun2_normal_web
         Fun_List;
         ;;
    s4|templerun2_normal_pvp)
	 echo -e "[`date`] templerun2_normal_pvp \n" 
	     templerun2_normal_pvp
         Fun_List;
         ;;
    s5|templerun2_restart_worker)
         echo -e "[`date`] templerun2_restart_worker  \n"  
         templerun2_restart_worker
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

