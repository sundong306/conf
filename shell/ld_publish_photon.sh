#!/bin/bash
# david.sun@idreamsky.com
# 2019.05.21
# v1.0  神庙逃亡2 正式服 更新
#############   contact: sundong306@foxmail.com
#############   /bin/bash  -x  ld_publish_3jianhao.sh   20180711
echo "++===================================================================================++"
echo "++                       乐逗运维-发布变更-维护工具                                  ++"
echo "++                                                                                   ++"
echo "++                      当前环境【TXY 神庙逃亡2  + 地铁跑酷  photon  线上环境】                             ++"
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
salt  Q-gz-comm-codeOri  cmd.run   runas=alan.lian  "cd /data/svn/alan.lian/subway/subway_pvp_gs_master           ;  svn  up"
salt  Q-gz-comm-codeOri  cmd.run   runas=alan.lian  "cd /data/svn/alan.lian/subway/subway_pvp_gs_game             ;  svn  up"
salt  Q-gz-comm-codeOri  cmd.run   runas=alan.lian  "cd /data/svn/alan.lian/subway/subway_pvp_gs_im               ;  svn  up"
####  把更新文件从 代码机 rsync 到  发布机 
/usr/bin/rsync -artzv   -e 'ssh -p 37878'  root@10.104.188.243:/data/svn/alan.lian/templerun/templerun_pvp_gs_master/  /data/ld_fabu/update/photon/templerun_pvp_gs_master/   --exclude=.svn    --exclude-from=/data/ld_fabu/conf/photon_no_rsync_file.txt 
/usr/bin/rsync -artzv   -e 'ssh -p 37878'  root@10.104.188.243:/data/svn/alan.lian/templerun/templerun_pvp_gs_game/  /data/ld_fabu/update/photon/templerun_pvp_gs_game/     --exclude=.svn    --exclude-from=/data/ld_fabu/conf/photon_no_rsync_file.txt 
/usr/bin/rsync -artzv   -e 'ssh -p 37878'  root@10.104.188.243:/data/svn/alan.lian/templerun/templerun_pvp_gs_im/ /data/ld_fabu/update/photon/templerun_pvp_gs_im/         --exclude=.svn    --exclude-from=/data/ld_fabu/conf/photon_no_rsync_file.txt 
/usr/bin/rsync -artzv   -e 'ssh -p 37878'  root@10.104.188.243:/data/svn/alan.lian/subway/subway_pvp_gs_master/ /data/ld_fabu/update/photon/subway_pvp_gs_master/          --exclude=.svn    --exclude-from=/data/ld_fabu/conf/photon_no_rsync_file.txt 
/usr/bin/rsync -artzv   -e 'ssh -p 37878'  root@10.104.188.243:/data/svn/alan.lian/subway/subway_pvp_gs_game/ /data/ld_fabu/update/photon/subway_pvp_gs_game/              --exclude=.svn    --exclude-from=/data/ld_fabu/conf/photon_no_rsync_file.txt 
/usr/bin/rsync -artzv   -e 'ssh -p 37878'  root@10.104.188.243:/data/svn/alan.lian/subway/subway_pvp_gs_im/ /data/ld_fabu/update/photon/subway_pvp_gs_im/  --exclude=.svn    --exclude-from=/data/ld_fabu/conf/photon_no_rsync_file.txt 
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
ssh  -f -n  -q Administrator@10.104.206.211  "cd /cygdrive/d/game/templerun_test_pvp_gs_Master/deploy/bin_Win64  ; ./photonSocketServer.exe   /stop"
ssh  -f -n  -q  Administrator@10.104.206.211  "cd /cygdrive/d/game/templerun_test_pvp_gs_Master/deploy/bin_Win64  ; ./photonSocketServer.exe /run LoadBalancing"
ssh  -f -n  -q  Administrator@10.104.185.128  "cd /cygdrive/d/game/templerun_test_pvp_gs_game/deploy/bin_Win64  ; ./photonSocketServer.exe   /stop"
ssh  -f -n  -q  Administrator@10.104.185.128  "cd /cygdrive/d/game/templerun_test_pvp_gs_game/deploy/bin_Win64  ; ./photonSocketServer.exe /run LoadBalancing"
ssh  -f -n  -q  Administrator@10.104.13.5     "cd /cygdrive/d/game/templerun_test_pvp_gs_im/deploy/bin_Win64  ; ./photonSocketServer.exe   /stop"
ssh  -f -n  -q  Administrator@10.104.13.5     "cd /cygdrive/d/game/templerun_test_pvp_gs_im/deploy/bin_Win64  ; ./photonSocketServer.exe /run IMService"

#地铁  Master  Game   IM
ssh  -f -n  -q  Administrator@10.104.59.171  "cd /cygdrive/d/game/subway_test_pvp_gs_Master/deploy/bin_Win64  ; ./photonSocketServer.exe   /stop"
ssh  -f -n  -q  Administrator@10.104.59.171  "cd /cygdrive/d/game/subway_test_pvp_gs_Master/deploy/bin_Win64  ; ./photonSocketServer.exe /run LoadBalancing"
ssh  -f -n  -q  Administrator@10.104.25.48   "cd /cygdrive/d/game/subway_test_pvp_gs_game/deploy/bin_Win64  ; ./photonSocketServer.exe   /stop"
ssh  -f -n  -q  Administrator@10.104.25.48   "cd /cygdrive/d/game/subway_test_pvp_gs_game/deploy/bin_Win64  ; ./photonSocketServer.exe /run LoadBalancing"
ssh  -f -n  -q  Administrator@10.104.31.113  "cd /cygdrive/d/game/subway_test_pvp_gs_im/deploy/bin_Win64  ; ./photonSocketServer.exe   /stop"
ssh  -f -n  -q  Administrator@10.104.31.113  "cd /cygdrive/d/game/subway_test_pvp_gs_im/deploy/bin_Win64  ; ./photonSocketServer.exe /run IMService"

}







############# 2.更新神庙逃亡2  正式环境            photon   （Master  Game  IM）
update_templerun_photon () {
echo  -e   " \n\033[32m 2.更新神庙逃亡2  正式环境            photon   （Master  Game  IM）  .......... \033[0m "
####  把更新文件从 发布机 rsync 到   各个模块
#/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/templerun_pvp_gs_master/  Administrator@10.104.206.211:/cygdrive/d/game/templerun_test_pvp_gs_Master/    
#神庙  
#Master  
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/templerun_pvp_gs_master/  Administrator@10.135.8.16:/cygdrive/d/game/templerun_pvp_gs_master/ 
#Game
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/templerun_pvp_gs_game/  Administrator@10.186.29.176:/cygdrive/d/game/templerun_pvp_gs_game/ 
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/templerun_pvp_gs_game/  Administrator@10.104.107.139:/cygdrive/d/game/templerun_pvp_gs_game/
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/templerun_pvp_gs_game/  Administrator@10.104.70.164:/cygdrive/d/game/templerun_pvp_gs_game/
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/templerun_pvp_gs_game/  Administrator@10.135.110.229:/cygdrive/d/game/templerun_pvp_gs_game/
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/templerun_pvp_gs_game/  Administrator@10.135.28.62:/cygdrive/d/game/templerun_pvp_gs_game/
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/templerun_pvp_gs_game/  Administrator@10.104.13.111:/cygdrive/d/game/templerun_pvp_gs_game/
#IM
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/templerun_pvp_gs_im/  Administrator@10.104.133.81:/cygdrive/d/game/templerun_pvp_gs_im_new/
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/templerun_pvp_gs_im/  Administrator@10.104.239.178:/cygdrive/d/game/templerun_pvp_gs_im_new/
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/templerun_pvp_gs_im/  Administrator@10.104.150.100:/cygdrive/d/game/templerun_pvp_gs_im_new/

####  重启  photon
#神庙  Master  Game   IM
ssh  -f -n  -q  Administrator@10.135.8.16  "cd /cygdrive/d/game/templerun_pvp_gs_master/deploy/bin_Win64  ; ./photonSocketServer.exe   /stop"
ssh  -f -n  -q  Administrator@10.135.8.16  "cd /cygdrive/d/game/templerun_pvp_gs_master/deploy/bin_Win64  ; ./photonSocketServer.exe /run LoadBalancing"

ssh  -f -n  -q  Administrator@10.186.29.176  "cd /cygdrive/d/game/templerun_pvp_gs_game/deploy/bin_Win64  ; ./photonSocketServer.exe   /stop"
ssh  -f -n  -q  Administrator@10.186.29.176   "cd /cygdrive/d/game/templerun_pvp_gs_game/deploy/bin_Win64  ; ./photonSocketServer.exe /run LoadBalancing"
ssh  -f -n  -q  Administrator@10.104.107.139  "cd /cygdrive/d/game/templerun_pvp_gs_game/deploy/bin_Win64  ; ./photonSocketServer.exe   /stop"
ssh  -f -n  -q  Administrator@10.104.107.139   "cd /cygdrive/d/game/templerun_pvp_gs_game/deploy/bin_Win64  ; ./photonSocketServer.exe /run LoadBalancing"
ssh  -f -n  -q  Administrator@10.104.70.164  "cd /cygdrive/d/game/templerun_pvp_gs_game/deploy/bin_Win64  ; ./photonSocketServer.exe   /stop"
ssh  -f -n  -q  Administrator@10.104.70.164   "cd /cygdrive/d/game/templerun_pvp_gs_game/deploy/bin_Win64  ; ./photonSocketServer.exe /run LoadBalancing"
ssh  -f -n  -q  Administrator@10.135.110.229  "cd /cygdrive/d/game/templerun_pvp_gs_game/deploy/bin_Win64  ; ./photonSocketServer.exe   /stop"
ssh  -f -n  -q  Administrator@10.135.110.229   "cd /cygdrive/d/game/templerun_pvp_gs_game/deploy/bin_Win64  ; ./photonSocketServer.exe /run LoadBalancing"
ssh  -f -n  -q  Administrator@10.135.28.62  "cd /cygdrive/d/game/templerun_pvp_gs_game/deploy/bin_Win64  ; ./photonSocketServer.exe   /stop"
ssh  -f -n  -q  Administrator@10.135.28.62   "cd /cygdrive/d/game/templerun_pvp_gs_game/deploy/bin_Win64  ; ./photonSocketServer.exe /run LoadBalancing"
ssh  -f -n  -q  Administrator@10.104.13.111  "cd /cygdrive/d/game/templerun_pvp_gs_game/deploy/bin_Win64  ; ./photonSocketServer.exe   /stop"
ssh  -f -n  -q  Administrator@10.104.13.111   "cd /cygdrive/d/game/templerun_pvp_gs_game/deploy/bin_Win64  ; ./photonSocketServer.exe /run LoadBalancing"

ssh  -f -n  -q  Administrator@10.104.133.81  "cd /cygdrive/d/game/templerun_pvp_gs_im_new/deploy/bin_Win64  ; ./photonSocketServer.exe   /stop"
ssh  -f -n  -q  Administrator@10.104.133.81  "cd /cygdrive/d/game/templerun_pvp_gs_im_new/deploy/bin_Win64  ; ./photonSocketServer.exe /run IMService"
ssh  -f -n  -q  Administrator@10.104.239.178  "cd /cygdrive/d/game/templerun_pvp_gs_im_new/deploy/bin_Win64  ; ./photonSocketServer.exe   /stop"
ssh  -f -n  -q  Administrator@10.104.239.178  "cd /cygdrive/d/game/templerun_pvp_gs_im_new/deploy/bin_Win64  ; ./photonSocketServer.exe /run IMService"
ssh  -f -n  -q  Administrator@10.104.150.100  "cd /cygdrive/d/game/templerun_pvp_gs_im_new/deploy/bin_Win64  ; ./photonSocketServer.exe   /stop"
ssh  -f -n  -q  Administrator@10.104.150.100  "cd /cygdrive/d/game/templerun_pvp_gs_im_new/deploy/bin_Win64  ; ./photonSocketServer.exe /run IMService"
}





############# 2.更新地铁跑酷  正式环境            photon   （Master  Game  IM）
update_subway_photon () {
echo  -e   " \n\033[32m 2.地铁跑酷 正式环境            photon   （Master  Game  IM）  .......... \033[0m "
####  把更新文件从 发布机 rsync 到   各个模块
#/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/templerun_pvp_gs_master/  Administrator@10.104.206.211:/cygdrive/d/game/templerun_test_pvp_gs_Master/     
#地铁  
#Master  
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/subway_pvp_gs_master/  Administrator@10.104.73.187:/cygdrive/d/game/subway_pvp_gs_master/ 

#Game   
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/subway_pvp_gs_game/  Administrator@10.186.5.162:/cygdrive/d/game/subway_pvp_gs_game/ 
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/subway_pvp_gs_game/  Administrator@10.104.191.199:/cygdrive/d/game/subway_pvp_gs_game/ 
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/subway_pvp_gs_game/  Administrator@10.135.122.252:/cygdrive/d/game/subway_pvp_gs_game/ 
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/subway_pvp_gs_game/  Administrator@10.104.61.10:/cygdrive/d/game/subway_pvp_gs_game/ 
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/subway_pvp_gs_game/  Administrator@10.104.204.36:/cygdrive/d/game/subway_pvp_gs_game/

#IM
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/subway_pvp_gs_im/  Administrator@10.135.161.113:/cygdrive/d/game/subway_pvp_gs_im/ 
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/subway_pvp_gs_im/  Administrator@10.135.126.173:/cygdrive/d/game/subway_pvp_gs_im/ 
/usr/bin/rsync -artzv   /data/ld_fabu/update/photon/subway_pvp_gs_im/  Administrator@10.135.91.44:/cygdrive/d/game/subway_pvp_gs_im/ 


####  重启  photon
#地铁  Master  Game   IM
ssh  -f -n  -q  Administrator@10.104.73.187  "cd /cygdrive/d/game/subway_pvp_gs_master/deploy/bin_Win64  ; ./photonSocketServer.exe   /stop"
ssh  -f -n  -q  Administrator@10.104.73.187  "cd /cygdrive/d/game/subway_pvp_gs_master/deploy/bin_Win64  ; ./photonSocketServer.exe /run LoadBalancing"

ssh  -f -n  -q  Administrator@10.186.5.162   "cd /cygdrive/d/game/subway_pvp_gs_game/deploy/bin_Win64  ; ./photonSocketServer.exe   /stop"
ssh  -f -n  -q  Administrator@10.186.5.162   "cd /cygdrive/d/game/subway_pvp_gs_game/deploy/bin_Win64  ; ./photonSocketServer.exe /run LoadBalancing"
ssh  -f -n  -q  Administrator@10.104.191.199   "cd /cygdrive/d/game/subway_pvp_gs_game/deploy/bin_Win64  ; ./photonSocketServer.exe   /stop"
ssh  -f -n  -q  Administrator@10.104.191.199   "cd /cygdrive/d/game/subway_pvp_gs_game/deploy/bin_Win64  ; ./photonSocketServer.exe /run LoadBalancing"
ssh  -f -n  -q  Administrator@10.135.122.252   "cd /cygdrive/d/game/subway_pvp_gs_game/deploy/bin_Win64  ; ./photonSocketServer.exe   /stop"
ssh  -f -n  -q  Administrator@10.135.122.252   "cd /cygdrive/d/game/subway_pvp_gs_game/deploy/bin_Win64  ; ./photonSocketServer.exe /run LoadBalancing"
ssh  -f -n  -q  Administrator@10.104.61.10   "cd /cygdrive/d/game/subway_pvp_gs_game/deploy/bin_Win64  ; ./photonSocketServer.exe   /stop"
ssh  -f -n  -q  Administrator@10.104.61.10   "cd /cygdrive/d/game/subway_pvp_gs_game/deploy/bin_Win64  ; ./photonSocketServer.exe /run LoadBalancing"
ssh  -f -n  -q  Administrator@10.104.204.36   "cd /cygdrive/d/game/subway_pvp_gs_game/deploy/bin_Win64  ; ./photonSocketServer.exe   /stop"
ssh  -f -n  -q  Administrator@10.104.204.36   "cd /cygdrive/d/game/subway_pvp_gs_game/deploy/bin_Win64  ; ./photonSocketServer.exe /run LoadBalancing"

ssh  -f -n  -q  Administrator@10.135.161.113  "cd /cygdrive/d/game/subway_pvp_gs_im/deploy/bin_Win64  ; ./photonSocketServer.exe   /stop"
ssh  -f -n  -q  Administrator@10.135.161.113  "cd /cygdrive/d/game/subway_pvp_gs_im/deploy/bin_Win64  ; ./photonSocketServer.exe /run IMService"
ssh  -f -n  -q  Administrator@10.135.126.173  "cd /cygdrive/d/game/subway_pvp_gs_im/deploy/bin_Win64  ; ./photonSocketServer.exe   /stop"
ssh  -f -n  -q  Administrator@10.135.126.173  "cd /cygdrive/d/game/subway_pvp_gs_im/deploy/bin_Win64  ; ./photonSocketServer.exe /run IMService"
ssh  -f -n  -q  Administrator@10.135.91.44  "cd /cygdrive/d/game/subway_pvp_gs_im/deploy/bin_Win64  ; ./photonSocketServer.exe   /stop"
ssh  -f -n  -q  Administrator@10.135.91.44  "cd /cygdrive/d/game/subway_pvp_gs_im/deploy/bin_Win64  ; ./photonSocketServer.exe /run IMService"

}




###### Last:更新操作提示语
Fun_List(){
echo 
cat << EOF
请选择操作:
##TXY 神庙逃亡2  + 地铁跑酷  photon  线上环境#
s1：更新神庙逃亡2  + 地铁跑酷  预发布   photon   （Master  Game  IM）   update_yufabu_photon
s2: 更新神庙逃亡2  正式环境            photon   （Master  Game  IM）   update_templerun_photon
s3: 更新地铁跑酷   正式环境            photon   （Master  Game  IM）   update_subway_photon

q: 退出
EOF


echo ""
echo "注意：【文件需要准备好，各操作步骤需要顺序执行】"
echo ""
read -p "请选操作项 :>" OPTION
case "$OPTION" in
    s1|update_yufabu_photon)
         echo -e "[`date`] update_yufabu_photon  \n"  
         update_yufabu_photon
         Fun_List;
         ;;
    s2|update_templerun_photon)
	 echo -e "[`date`] update_templerun_photon \n" 
	     update_templerun_photon
         Fun_List;
         ;;
    s3|update_subway_photon)
	 echo -e "[`date`] update_subway_photon \n" 
	     update_subway_photon
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