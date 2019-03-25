#!/bin/bash

Program_path=/home/data/run/game/backup_update
Remote_path=/home/gcgame
Backup_path=/home/data/game/config/backup
Update_path=/home/data/game/config/update

##define Statistics number.
Succ=0
Fail=0
Failed_Ip=""


## function
syncGameConfig(){
        GAME_IP=$1
        echo $GAME_IP |egrep "[a-Z]"  >/dev/null
        if [ $? == 0 ]
        then
                echo -e "!!\n!!\n!!\n$GAME_IP format error\n!!\n!!\n!!"
                Fail=`expr $Fail + 1`
                Failed_Ip=$GAME_IP"\b"$Failed_Ip
                continue
        else
                /usr/bin/rsync -avze ssh --itemize-changes --bwlimit=10000 --exclude=run --exclude=flash_cross --exclude=core\.* --exclude=log/* --exclude=\.* --delete gcgame@${GAME_IP}:${Remote_path}/ ${Backup_path}/${GAME_IP}/
                if [ $? == 0 ]
                then
                        Succ=`expr $Succ + 1`
                else
                        Fail=`expr $Fail + 1`
                        Failed_Ip=$IP"\b"$Failed_Ip
                fi
        fi
####
echo -e "\n########################################################\n#"
echo -e "#  Succ:\033[32m$Succ\033[0m\tFailed:\033[31m$Fail\033[0m"
echo -e "#\n########################################################\n"
####
}

## main

echo -e "\n\033[32m========= Now backup config ==========\033[0m"
cat ${Program_path}/radiuslist.txt ${Program_path}/gamelist.txt | grep -v "^#\|^$" | while read IP
do
        echo -e "\n\033[32m## $IP ##\033[0m"
        syncGameConfig $IP
done

## sync local
echo -e "\n\033[32mNow sync in local\033[0m"
rsync -avz --itemize-changes --delete ${Backup_path}/ ${Update_path}/
echo -e "\n\033[32mBackup done\033[0m"
