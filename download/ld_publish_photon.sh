#!/bin/bash
# david.sun@idreamsky.com
# 2019.05.21
# v1.0  神庙逃亡2 正式服 更新
#############   contact: sundong306@foxmail.com
#############   /bin/bash  -x  ld_publish_3jianhao.sh   20180711
echo "++===================================================================================++"
echo "++                       乐逗运维-发布变更-维护工具                                  ++"
echo "++                                                                                   ++"
echo "++                      当前环境【TXY 神庙逃亡2  + 地铁跑酷  photon  线上环境】    	                  ++"
echo "++===================================================================================++"

##ledou00
if [ $USER != root ]
then
        echo "only root can run this script!"
        exit 1
fi


############# 1.更新神庙逃亡2  + 地铁跑酷  预发布   photon   （Master  Game  IM）
update_yufabu_photon () {
echo  -e   " \n\033[32m 1.更新神庙逃亡2  + 地铁跑酷  预发布   photon   （Master  Game  IM）  .......... \033[0m "
#####  svn  up
salt  Q-gz-comm-codeOri  cmd.run   runas=alan.lian  "cd /data/svn/alan.lian/templerun/templerun_pvp_gs_master ;  svn  up"
salt  Q-gz-comm-codeOri  cmd.run   runas=alan.lian  "cd /data/svn/alan.lian/templerun/templerun_pvp_gs_game   ;  svn  up"
salt  Q-gz-comm-codeOri  cmd.run   runas=alan.lian  "cd /data/svn/alan.lian/templerun/templerun_pvp_gs_im     ;  svn  up"
salt  Q-gz-comm-codeOri  cmd.run   runas=alan.lian  "cd /data/svn/alan.lian/subway/subway_pvp_gs_master		  ;  svn  up"
salt  Q-gz-comm-codeOri  cmd.run   runas=alan.lian  "cd /data/svn/alan.lian/subway/subway_pvp_gs_game		  ;  svn  up"
salt  Q-gz-comm-codeOri  cmd.run   runas=alan.lian  "cd /data/svn/alan.lian/subway/subway_pvp_gs_im 		  ;  svn  up"
####  把更新文件从 代码机 rsync 到  发布机 
/usr/bin/rsync -artzv   -e 'ssh -p 37878'  root@10.104.188.243:/data/svn/alan.lian/templerun/templerun_pvp_gs_master/  /data/ld_fabu/update/photon/templerun_pvp_gs_master   --exclude=.svn    --exclude-from=/data/ld_fabu/conf/photon_no_rsync_file.txt 
/usr/bin/rsync -artzv   -e 'ssh -p 37878'  root@10.104.188.243:/data/svn/alan.lian/templerun/templerun_pvp_gs_game/    /data/ld_fabu/update/photon/templerun_pvp_gs_game     --exclude=.svn    --exclude-from=/data/ld_fabu/conf/photon_no_rsync_file.txt 
/usr/bin/rsync -artzv   -e 'ssh -p 37878'  root@10.104.188.243:/data/svn/alan.lian/templerun/templerun_pvp_gs_im/ 	   /data/ld_fabu/update/photon/templerun_pvp_gs_im  	 --exclude=.svn    --exclude-from=/data/ld_fabu/conf/photon_no_rsync_file.txt 
/usr/bin/rsync -artzv   -e 'ssh -p 37878'  root@10.104.188.243:/data/svn/alan.lian/subway/subway_pvp_gs_master		   /data/ld_fabu/update/photon/subway_pvp_gs_master  	 --exclude=.svn    --exclude-from=/data/ld_fabu/conf/photon_no_rsync_file.txt 
/usr/bin/rsync -artzv   -e 'ssh -p 37878'  root@10.104.188.243:/data/svn/alan.lian/subway/subway_pvp_gs_game		  /data/ld_fabu/update/photon/subway_pvp_gs_game  		 --exclude=.svn    --exclude-from=/data/ld_fabu/conf/photon_no_rsync_file.txt 
/usr/bin/rsync -artzv   -e 'ssh -p 37878'  root@10.104.188.243:/data/svn/alan.lian/subway/subway_pvp_gs_im			  /data/ld_fabu/update/photon/subway_pvp_gs_im 			  --exclude=.svn    --exclude-from=/data/ld_fabu/conf/photon_no_rsync_file.txt 
####  把更新文件从 发布机 rsync 到   各个模块
#/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/templerun_pvp_gs_master/  Administrator@10.104.206.211:/cygdrive/d/game/templerun_test_pvp_gs_Master/    
#神庙  Master  Game   IM
#templerun2-pvp-gs-test1    
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/templerun_pvp_gs_master/  Administrator@10.104.206.211:/cygdrive/d/game/templerun_test_pvp_gs_Master/ 
#templerun2-pvp-gs-test2
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/templerun_pvp_gs_game/  Administrator@10.104.185.128:/cygdrive/d/game/templerun_test_pvp_gs_game/ 
#templerun2-pvp-gs-test3
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/templerun_pvp_gs_im/  Administrator@10.104.13.5:/cygdrive/d/game/templerun_test_pvp_gs_im/
#地铁  Master  Game   IM
#templerun2-pvp-gs-test4
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/subway_pvp_gs_master/  Administrator@10.104.59.171:/cygdrive/d/game/subway_test_pvp_gs_Master/ 
#templerun2-pvp-gs-test5
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/subway_pvp_gs_game/  Administrator@10.104.25.48:/cygdrive/d/game/subway_test_pvp_gs_game/ 
#templerun2-pvp-gs-test6
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/subway_pvp_gs_im/  Administrator@10.104.31.113:/cygdrive/d/game/subway_test_pvp_gs_im/ 


####  重启  photon
#神庙  Master  Game   IM
ssh   -f  -n  -q      Administrator@10.104.206.211  "cd /cygdrive/d/game/templerun_test_pvp_gs_Master/deploy/bin_Win64/;./photonSocketServer.exe   /stop"
ssh   -f  -n  -q      Administrator@10.104.206.211  "cd /cygdrive/d/game/templerun_test_pvp_gs_Master/deploy/bin_Win64/;./photonSocketServer.exe /run LoadBalancing  ; exit"
ssh   -f  -n  -q      Administrator@10.104.185.128  "cd /cygdrive/d/game/templerun_test_pvp_gs_game/deploy/bin_Win64/;./photonSocketServer.exe   /stop"
ssh   -f  -n  -q      Administrator@10.104.185.128  "cd /cygdrive/d/game/templerun_test_pvp_gs_game/deploy/bin_Win64/;./photonSocketServer.exe /run LoadBalancing  ; exit"
ssh   -f  -n  -q      Administrator@10.104.13.5	   "cd /cygdrive/d/game/templerun_test_pvp_gs_im/deploy/bin_Win64/;./photonSocketServer.exe   /stop"
ssh   -f  -n  -q      Administrator@10.104.13.5	   "cd /cygdrive/d/game/templerun_test_pvp_gs_im/deploy/bin_Win64/;./photonSocketServer.exe /run IMService		 ; exit"

#地铁  Master  Game   IM
ssh   -f  -n  -q      Administrator@10.104.59.171  "cd /cygdrive/d/game/subway_test_pvp_gs_Master/deploy/bin_Win64/;./photonSocketServer.exe   /stop"
ssh   -f  -n  -q      Administrator@10.104.59.171  "cd /cygdrive/d/game/subway_test_pvp_gs_Master/deploy/bin_Win64/;./photonSocketServer.exe /run LoadBalancing	; exit"
ssh   -f  -n  -q      Administrator@10.104.25.48   "cd /cygdrive/d/game/subway_test_pvp_gs_game/deploy/bin_Win64/;./photonSocketServer.exe   /stop"
ssh   -f  -n  -q      Administrator@10.104.25.48   "cd /cygdrive/d/game/subway_test_pvp_gs_game/deploy/bin_Win64/;./photonSocketServer.exe /run LoadBalancing; exit"
ssh   -f  -n  -q      Administrator@10.104.25.113  "cd /cygdrive/d/game/subway_test_pvp_gs_im/deploy/bin_Win64/;./photonSocketServer.exe   /stop"
ssh   -f  -n  -q      Administrator@10.104.31.113  "cd /cygdrive/d/game/subway_test_pvp_gs_im/deploy/bin_Win64/;./photonSocketServer.exe /run IMService		; exit"
}








############# 2.更新神庙逃亡2  正式环境            photon   （Master  Game  IM）
update_templerun_photon () {
echo  -e   " \n\033[32m 2.更新神庙逃亡2  正式环境            photon   （Master  Game  IM）  .......... \033[0m "
####  把更新文件从 发布机 rsync 到   各个模块
#/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/templerun_pvp_gs_master/  Administrator@10.104.206.211:/cygdrive/d/game/templerun_test_pvp_gs_Master/    
#神庙  Master  Game   IM
#templerun2-pvp-gs-test1    
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/templerun_pvp_gs_master/  Administrator@10.104.206.211:/cygdrive/d/game/templerun_test_pvp_gs_Master/ 
#templerun2-pvp-gs-test2
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/templerun_pvp_gs_game/  Administrator@10.104.185.128:/cygdrive/d/game/templerun_test_pvp_gs_game/ 
#templerun2-pvp-gs-test3
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/templerun_pvp_gs_im/  Administrator@10.104.13.5:/cygdrive/d/game/templerun_test_pvp_gs_im/
#地铁  Master  Game   IM
#templerun2-pvp-gs-test4
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/subway_pvp_gs_master/  Administrator@10.104.59.171:/cygdrive/d/game/subway_test_pvp_gs_Master/ 
#templerun2-pvp-gs-test5
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/subway_pvp_gs_game/  Administrator@10.104.25.48:/cygdrive/d/game/subway_test_pvp_gs_game/ 
#templerun2-pvp-gs-test6
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/subway_pvp_gs_im/  Administrator@10.104.31.113:/cygdrive/d/game/subway_test_pvp_gs_im/ 


####  重启  photon
#神庙  Master  Game   IM
ssh  Administrator@10.104.206.211  "cd /cygdrive/d/game/templerun_test_pvp_gs_Master/   ;  ./deploy/bin_Win64/photonSocketServer.exe   /stop"
ssh  Administrator@10.104.206.211  "cd /cygdrive/d/game/templerun_test_pvp_gs_Master/   ;  ./deploy/bin_Win64/photonSocketServer.exe /run LoadBalancing"
ssh  Administrator@10.104.185.128  "cd /cygdrive/d/game/templerun_test_pvp_gs_game/   ;  ./deploy/bin_Win64/photonSocketServer.exe   /stop"
ssh  Administrator@10.104.185.128  "cd /cygdrive/d/game/templerun_test_pvp_gs_game/   ;  ./deploy/bin_Win64/photonSocketServer.exe /run LoadBalancing"
ssh  Administrator@10.104.13.5	   "cd /cygdrive/d/game/templerun_test_pvp_gs_im/   ;  ./deploy/bin_Win64/photonSocketServer.exe   /stop"
ssh  Administrator@10.104.13.5	   "cd /cygdrive/d/game/templerun_test_pvp_gs_im/   ;  ./deploy/bin_Win64/photonSocketServer.exe /run IMService"

#地铁  Master  Game   IM
ssh  Administrator@10.104.59.171  "cd /cygdrive/d/game/subway_test_pvp_gs_Master/   ;  ./deploy/bin_Win64/photonSocketServer.exe   /stop"
ssh  Administrator@10.104.59.171  "cd /cygdrive/d/game/subway_test_pvp_gs_Master/   ;  ./deploy/bin_Win64/photonSocketServer.exe /run LoadBalancing"
ssh  Administrator@10.104.25.48   "cd /cygdrive/d/game/subway_test_pvp_gs_game/   ;  ./deploy/bin_Win64/photonSocketServer.exe   /stop"
ssh  Administrator@10.104.25.48   "cd /cygdrive/d/game/subway_test_pvp_gs_game/   ;  ./deploy/bin_Win64/photonSocketServer.exe /run LoadBalancing"
ssh  Administrator@10.104.31.113  "cd /cygdrive/d/game/subway_test_pvp_gs_im/   ;  ./deploy/bin_Win64/photonSocketServer.exe   /stop"
ssh  Administrator@10.104.31.113  "cd /cygdrive/d/game/subway_test_pvp_gs_im/   ;  ./deploy/bin_Win64/photonSocketServer.exe /run IMService"

}































###### Last:更新操作提示语
Fun_List(){
echo 
cat << EOF
请选择操作:
##TXY 神庙逃亡2  + 地铁跑酷  photon  线上环境#
s1：更新神庙逃亡2  + 地铁跑酷  预发布   photon   （Master  Game  IM）
s2: 更新神庙逃亡2  正式环境            photon   （Master  Game  IM）
s3: 更新地铁跑酷   正式环境            photon   （Master  Game  IM）

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