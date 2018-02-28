#!/bin/bash

project_path=/home/gcweb/usr/local/$1/webapps
date_time=`date +'%y%m%d%H%M'`

[ ! -d ${project_path} ] && echo "$1 isn't exits!" && exit
[ -d ${project_path} ] && cd ${project_path} && tar zcf ROOT${date_time}.tar.gz ROOT && echo "tar is OK"

