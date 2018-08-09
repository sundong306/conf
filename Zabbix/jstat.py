#!/usr/bin/env python
#coding=utf-8
'''
##
## 功能: 调用jstat获取JMX的各项指标
## 说明: 用于zabbix自动发现告警
## 版本: V1.0 2016-11-02
## 特性: 1. 线程功能，提高脚本执行速度
##
'''

import sys
import os
import commands
import subprocess
import json
import argparse
import socket
import threading

jstat_cmd = commands.getoutput("which jstat")
jstack_cmd = commands.getoutput("which jstack")
jvmport_cmd = "netstat -tpnl|grep -oP '(?<=:)\d+.*\d+(?=/java)'|awk '{print $1,$NF}'|grep -E '808[0-9]|8899|7074'"

hostname = socket.gethostname()
zbx_sender='/usr/local/zabbix/bin/zabbix_sender'
zbx_cfg='/usr/local/zabbix/etc/zabbix_agentd.conf'
zbx_tmp_file='/usr/local/zabbix/scripts/.zabbix_jmx_status'

jstat_dict = {
        "S0":"Young.Space0.Percent",
        "S1":"Young.Space1.Percent",
        "E":"Eden.Space.Percent",
        "O":"Old.Space.Percent",
        "P":"Perm.Space.Percent",
        "FGC":"Old.Gc.Count",
        "FGCT":"Old.Gc.Time",
        "YGC":"Young.Gc.Count",
        "YGCT":"Young.Gc.Time",
        "GCT":"Total.Gc.Time",
        "PGCMN":"Perm.Gc.Min",
        "PGCMX":"Perm.Gc.Max",
        "PGC":"Perm.Gc.New",
        "PC":"Perm.Gc.Cur",
        "Tomcat.Thread":"Tomcat.Thread"
    }

jmx_threads = []

def get_status(cmd,opts,pid):
    value = commands.getoutput('sudo %s -%s %s' % (cmd,opts,pid)).strip().split('\n')

    kv = []
    for i in value[0].split(' '):
        if i != '':
            kv.append(i)

    vv = []
    for i in value[1].split(' '):
        if i != '':
            vv.append(i)

    data = dict(zip(kv,vv))
    return data

def get_thread(cmd,pid):
    value = commands.getoutput('sudo %s %s|grep http|wc -l' % (cmd,pid))
    data = {"Tomcat.Thread":value}
    return data

def get_jmx(jport,jprocess):
    '''
      使用jstat获取Java的性能指标
    '''
    
    file_truncate()    # 清空zabbix_data_tmp

    gcutil_data = get_status(jstat_cmd,"gcutil",jprocess)
    gccapacity_data = get_status(jstat_cmd,"gccapacity",jprocess)
    thread_data = get_thread(jstack_cmd,jprocess)
    data_dict = dict(gcutil_data.items()+gccapacity_data.items()+thread_data.items())

    for jmxkey in data_dict.keys():
        if jmxkey in jstat_dict.keys():
            cur_key = jstat_dict[jmxkey]
            zbx_data = "%s jstat[%s,%s] %s" %(hostname,jport,cur_key,data_dict[jmxkey])
            with open(zbx_tmp_file,'a') as file_obj: file_obj.write(zbx_data + '\n')

def jvm_port_discovery():
    output = subprocess.Popen(jvmport_cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    jvm_port_lists = output.stdout.readlines()
    jvm_port_proce = []
    for jvm_port_tmp in jvm_port_lists:
         jvm_port_proce.append(jvm_port_tmp.split())
    return jvm_port_proce
    

def file_truncate():
    '''
      用于清空zabbix_sender使用的临时文件
    '''
    with open(zbx_tmp_file,'w') as fn: fn.truncate()

def zbx_tmp_file_create():
    '''
      创建zabbix_sender发送的文件内容
    '''
    jvmport_list = jvm_port_discovery()
    for jvm_tmp in jvmport_list:
        jvmport = jvm_tmp[0]
        jvmprocess = jvm_tmp[1]
        th = threading.Thread(target=get_jmx,args=(jvmport,jvmprocess))
        th.start()
        jmx_threads.append(th)

def send_data_zabbix():
    '''
      调用zabbix_sender命令，将收集的key和value发送至zabbix server
    '''
    zbx_tmp_file_create()
    for get_jmxdata in jmx_threads:
        get_jmxdata.join()
    zbx_sender_cmd = "%s -c %s -i %s" %(zbx_sender,zbx_cfg,zbx_tmp_file)
    print zbx_sender_cmd
    zbx_sender_status,zbx_sender_result = commands.getstatusoutput(zbx_sender_cmd)
    #print zbx_sender_status
    print zbx_sender_result

def zbx_discovery():
    '''
      用于zabbix自动发现JVM端口
    '''
    jvm_zabbix = []
    jvmport_list = jvm_port_discovery()
    for jvm_tmp in jvmport_list:
        jvm_zabbix.append({'{#JPORT}' : jvm_tmp[0],
                           '{#JPROCESS}' : jvm_tmp[1],
                         })
    return json.dumps({'data': jvm_zabbix}, sort_keys=True, indent=7,separators=(',', ':'))

def cmd_line_opts(arg=None):
    class ParseHelpFormat(argparse.HelpFormatter):
        def __init__(self, prog, indent_increment=5, max_help_position=50, width=200):
            super(ParseHelpFormat, self).__init__(prog, indent_increment, max_help_position, width)

    parse = argparse.ArgumentParser(description='Jmx监控"',
                                    formatter_class=ParseHelpFormat)
    parse.add_argument('--version', '-v', action='version', version="0.1", help='查看版本')
    parse.add_argument('--jvmport', action='store_true', help='获取JVM端口')
    parse.add_argument('--data', action='store_true', help='发送JMX指标数据至zabbix')

    if arg:
        return parse.parse_args(arg)
    if not sys.argv[1:]:
        return parse.parse_args(['-h'])
    else:
        return parse.parse_args()


if __name__ == '__main__':
    opts = cmd_line_opts()
    if opts.jvmport:
        print zbx_discovery()
    elif opts.data:
        send_data_zabbix()
    else:
        cmd_line_opts(arg=['-h'])

