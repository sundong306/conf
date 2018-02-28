#!/bin/bash

####
Program_path=/home/gcweb/crontab

####
syncProject(){
        IP=$1
        Project=$2
        echo -e "\033[32m###* ${IP} -- ${Project} *###\033[0m"
        case ${Project} in

                isd[0-9]*)
                        Src_path=/home/gcweb/home/isd1/webapps/ROOT
                        Dst_path=/home/gcweb/home/${Project}/webapps/ROOT
                        ;;

                wxsd[0-9]*)
                        Src_path=/home/gcweb/home/wxsd1/webapps/ROOT
                        Dst_path=/home/gcweb/home/${Project}/webapps/ROOT
                        ;;

        esac
        if [ ! -z "${Src_path}" -a ! -z "${Dst_path}" ];then
                /usr/bin/rsync -zrtopgcle ssh --itemize-changes --delete ${Src_path}/ gcweb@${IP}:${Dst_path}/
        else
                echo -e "\033[31mWarnging: source path or destination path error###\033[0m"
        fi
          
}

####
cat ${Program_path}/interfacelist.txt | grep -v "^$\|^#" |  while read IP Project
do
        syncProject ${IP} ${Project}
done
