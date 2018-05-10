#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys,requests,json, socket
class Dnspod:			
    def __init__(self,token):
        self.token = token

    def getDomainList(self):
        postdata = {'login_token': self.token,'format':'json'}
        with requests.session() as start:
            login = start.post('https://dnsapi.cn/Domain.List',postdata)
            return login.text

    def getSub(self,domain):
        sub = domain.split('.')[0]
        num =  len(domain.split('.'))
        if num == 3 :
            root =  domain.split('.')[1] + '.' + domain.split('.')[2]
        elif num  == 4 :
            root =  domain.split('.')[1] + '.' + domain.split('.')[2] + '.'  + domain.split('.')[3]
        else :
            print  ('\033[1;33;44m ERROR,域名输入格式不对，请检查！ \033[0m')
	    sys.exit(0)
        return sub,root
		
    def getDns(self,domain):
        try:
            ip = socket.gethostbyname(domain)
	    print  ('\033[1;33;44m 输入的主机记录存在 可以被修改或者删除!\033[0m')
        except socket.error as e:
            print  ('\033[1;33;44m账户中未找到该域名对应的主机记录!\033[0m')
            sys.exit(0)
	return ip

    def getRecord(self,domain):
        sub,root=self.getSub(domain)
        postdata = {'login_token': self.token,'format':'json','domain':root,'sub_domain':sub}
        with requests.session() as start:
            login = start.post('https://dnsapi.cn/Record.List',postdata)
            return json.loads(login.text)['records'][0]['id'],json.loads(login.text)['records'][0]['value']
			
    def addRecord(self,domain,ip,record_type,record_line):
        sub,root = self.getSub(domain)
        postdata = {'login_token': self.token,'format':'json','domain':root,'sub_domain':sub,'value':ip,'record_type':record_type,'record_line':record_line}
        with requests.session() as start:
            login = start.post('https://dnsapi.cn/Record.Create',postdata)
            if json.loads(login.text)['status']['code'] == '1':
                return 'success'
            else:
                return json.loads(login.text)			


    def change1(self,domain,ip,record_type,record_line):
       sub,root=self.getSub(domain)
       all_domains=[]
       for domain_name in  json.loads(self.getDomainList())['domains']:
           all_domains.append(domain_name['name'])
       if root not in all_domains:
           print  ('\033[1;33;44m 账户中未找到该域名!\033[0m')
           sys.exit(0)
       print '域名: '+ domain + ' 添加解析为: ' + ip + ' 记录类型: ' + record_type + ' 线路: ' + record_line  +' 状态: ' +str(self.addRecord(domain,ip,record_type,record_line))

    def modRecord(self,domain,ip,record_type,record_line):
        sub,root = self.getSub(domain)
        record_id,value = self.getRecord(domain)
        postdata = {'login_token': self.token,'format':'json','domain':root,'sub_domain':sub,'record_id':record_id,'value':ip,'record_type':record_type,'record_line':record_line}
        with requests.session() as start:
            login = start.post('https://dnsapi.cn/Record.Modify',postdata)
            if json.loads(login.text)['status']['code'] == '1':
                return 'success'
            else:
                return json.loads(login.text)				

    def change2(self,domain,ip,record_type,record_line):
       self.getDns(domain)
       sub,root = self.getSub(domain)
       all_domains=[]
       for domain_name in  json.loads(self.getDomainList())['domains']:
           all_domains.append(domain_name['name'])
       if root not in all_domains:
           print   ('\033[1;33;44m账户中未找到该域名!\033[0m')
           sys.exit(0)
       print '域名: '+ domain +  ' 当前解析: ' + str(self.getRecord(domain)[1]) +  ' 更改解析为: ' + ip + ' 记录类型: ' + record_type + ' 线路: ' + record_line  +' 状态: ' +str(self.modRecord(domain,ip,record_type,record_line))

    def delRecord(self,domain):
        sub,root = self.getSub(domain)
        record_id,value = self.getRecord(domain)      
        postdata = {'login_token': self.token,'format':'json','domain':root,'sub_domain':sub,'record_id':record_id}
        with requests.session() as start:
            login = start.post('https://dnsapi.cn/Record.Remove',postdata)
            if json.loads(login.text)['status']['code'] == '1':
                return 'success'
            else:
                return json.loads(login.text)
    def change3(self,domain):
       self.getDns(domain)
       sub,root = self.getSub(domain)
       all_domains=[]
       for domain_name in  json.loads(self.getDomainList())['domains']:
           all_domains.append(domain_name['name'])
       if root not in all_domains:
           print   ('\033[1;33;44m 账户中未找到该域名!\033[0m')
           sys.exit(0)
       print '域名: '+ domain +  ' 当前解析: ' + ' 已经删除！！！ '  +str(self.delRecord(domain))



if __name__ == '__main__':
	Token = '54169,b932bcdb69d5232f3f46ccfb4e76388b'
	Action = int(raw_input("请选择一个数字 1:添加一条域名解析 2:一条修改域名解析 3:删除一条域名解析 4：退出---------------- "))
	if	Action == 1 :
		domain = raw_input('请输入DNSPod domain 添加一条域名解析 :')
		ip = raw_input('请输入DNSPod记录值  ip:')
		record_type = raw_input('请输入DNSPod A MX TXT  记录类型:')
		record_line = raw_input('请输入DNSPod 默认 国内 国外 线路类型:')
		Dnspod(Token).change1(domain, ip, record_type, record_line)
	elif	Action == 2 :
        	domain = raw_input('请输入DNSPod domain 修改一条域名解析 :')
        	ip = raw_input('输入DNSPod记录值  ip:')
        	record_type = raw_input('请输入DNSPod A MX TXT  记录类型:')
        	record_line = raw_input('请输入DNSPod 默认 国内 国外 线路类型:')
        	Dnspod(Token).change2(domain, ip, record_type, record_line)
	elif	Action == 3 :			
		domain = raw_input('请输入DNSPod domain 删除一条域名解析 :')
		Dnspod(Token).change3(domain)
	else 	:
		print "退出脚本"



