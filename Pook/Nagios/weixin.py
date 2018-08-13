#!/usr/bin/python2.6
#-.- encoding: utf-8 -.-

import os
import sys
import time
import json
import urllib2
import smtplib
import getpass
from urllib import urlencode
from optparse import OptionParser
from email.MIMEText import MIMEText

def getToken(id, secret, tokenfile, ifget=0, timeout=3):
    urllib2.socket.setdefaulttimeout(timeout)
    tokenlist = []
    c_time = int(time.time())
    params = urlencode({'corpid': id, 'corpsecret': secret})
    apiurl = 'https://qyapi.weixin.qq.com/cgi-bin/gettoken?' + params
    try:
        with open(tokenfile) as f:
            tokenlist = f.readlines()
            if len(tokenlist) == 2 and c_time < int(tokenlist[1].strip()) and not ifget:
                token = tokenlist[0].strip()
                expires = tokenlist[1].strip()
            else:
               raise Exception
    except Exception:
        with open(tokenfile, 'w') as f:
            try:
                req = urllib2.Request(apiurl)
                response = urllib2.urlopen(req).read()
                token = json.loads(response).get('access_token')
                expires = int(json.loads(response).get('expires_in', 0)) + c_time
                f.write('%s\n%s' % (token, expires))
            except Exception, e:
                token = ''
                #print(e)
    return token

def alertByWx(token, body, timeout=5):
    urllib2.socket.setdefaulttimeout(timeout)
    params = urlencode({'access_token': token})
    apiurl = 'https://qyapi.weixin.qq.com/cgi-bin/message/send?' + params
    data = json.dumps(body)
    try:
        opener = urllib2.build_opener()
        response = opener.open(apiurl, data).read()
        result = json.loads(response)
        if result.get('errcode') != 0:
            raise Exception, result
    except Exception, e:
        return e

def alertByEmail(subject, msg, mailto):
    senduser = getpass.getuser()
    smail = smtplib.SMTP('127.0.0.1')
    message = MIMEText(msg, 'html', _charset='utf-8')
    message['From'] = senduser
    message['To'] = mailto
    message['Subject'] = subject
    smail.sendmail('root@localhost', mailto, message.as_string())
    smail.quit()

def printOption():
    parse = OptionParser(usage = 'Usage: %prog [option] arg', version='%prog 1.01') 
    parse.add_option('-u', '--user', dest='username', help='Alert user name, separate by ","', default='@all')
    parse.add_option('-s', '--subject', dest='subject', help='Subject content, default "Alert"', default="Alert")
    parse.add_option('-m', '--message', dest='message', help='Message content, default "Alert"', default="Alert")
    parse.add_option('-i', '--id', dest='agentid', type='int', help='Agent id, default 1', default=1)
    parse.add_option('-t', '--touser', dest='touser', help='Mail address, separate by ";".if webchat send failed, send mail', default='sundong@hbv5.cn')
    (parser, args) = parse.parse_args()
    if len(sys.argv) < 2:
        parse.print_help()
        sys.exit(2)
    else:
        return parser

if __name__ == '__main__':
    
    reload(sys)
    sys.setdefaultencoding('utf-8')

    corpid = 'wx3e81b298d59f21bd'
    corpsecret = '****************'
    tokenfile = '/etc/tokenfile.conf'
    if os.path.isfile('/etc/tokenfile.conf'):
        tokenfile = '/tmp/tokenfile.conf'
    parser = printOption()
    token = getToken(corpid, corpsecret, tokenfile, 0)
    mailto = parser.touser
    touser = parser.username.replace(',', '|')
    subject = parser.subject
    msg =  parser.message
    agentid = parser.agentid
    content = '%s\n%s' % (subject, msg)
    body = {'msgtype': 'text',
            'touser': touser,
            'text': {'content': content},
            'agentid': agentid,
            'safe': '0',
            }
    if token:
        result = alertByWx(token, body)
        if result:
            alertByEmail(subject, msg, mailto)
    else:
        alertByEmail(subject, msg, mailto)
    
