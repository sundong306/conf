#!/usr/bin/python
# -*- coding: UTF-8 -*-
import xlrd , os , sys , xlsxwriter
#打开excel文件并获取所有sheet 
Data = xlrd.open_workbook("bill_01.xlsx")  
#sheet eip ecs db redis ks3 bws 
Table1 = Data.sheet_by_index(1)
Table2 = Data.sheet_by_index(2)
Table3 = Data.sheet_by_index(3)
Table4 = Data.sheet_by_index(4)
Table5 = Data.sheet_by_index(5)
Table6 = Data.sheet_by_index(6)
 
#行的值
#NR = Table2.nrows
#NC = Table2.ncols
#print NR,NC
#打印表2数据
#Table2 =  Data.sheet_by_index(1)
#print Table2.name,Table2.nrows,Table2.ncols
#print  str(Data.sheet_names()).decode("unicode_escape").encode("utf8")
#获取指定单元格
NR1 = Table1.nrows
NR2 = Table2.nrows
NR3 = Table3.nrows
NR4 = Table4.nrows
NR5 = Table5.nrows
NR6 = Table6.nrows

####  获取项目eip ecs db redis 的数量和价格
#eip
__file__ = open(r'log1.txt', 'a')
for i in xrange (NR1) :
        print  >> __file__, Table1.cell(i,5).value.encode('utf-8') , Table1.cell(i,14).value.encode('utf-8')
__file__.close()
os.popen("grep  K log1.txt |awk -F '-' '{print $2,$NF}' | awk '{print $1,$NF}' > eip.txt ; > log1.txt")

#ecs
__file__ = open(r'log1.txt', 'a')
for i in xrange (NR2) :
        print  >> __file__, Table2.cell(i,5).value.encode('utf-8'), Table2.cell(i,14).value.encode('utf-8')
__file__.close()
os.popen("grep  K log1.txt |awk -F '-' '{print $2,$NF}' | awk '{print $1,$NF}' > ecs.txt ; > log1.txt")

#db
__file__ = open(r'log1.txt', 'a')
for i in xrange (NR3) :
        print  >> __file__, Table3.cell(i,5).value.encode('utf-8'), Table3.cell(i,14).value.encode('utf-8')
__file__.close()
os.popen("grep  K log1.txt |awk -F '-' '{print $2,$NF}' | awk '{print $1,$NF}' > db.txt ; > log1.txt")

#redis
__file__ = open(r'log1.txt', 'a')
for i in xrange (NR4) :
        print  >> __file__, Table4.cell(i,5).value.encode('utf-8'), Table4.cell(i,14).value.encode('utf-8')
__file__.close()
os.popen("grep  K log1.txt |awk -F '-' '{print $2,$NF}' | awk '{print $1,$NF}' > redis.txt ; > log1.txt")
#bws
__file__ = open(r'log1.txt', 'a')
for i in xrange (NR6) :
        print  >> __file__, Table6.cell(i,2).value.encode('utf-8'),Table6.cell(i,14).value.encode('utf-8')
__file__.close()
os.popen("grep  73401233  log1.txt  > bws.txt ; > log1.txt").read()
os.popen("sed -i   's/73401233/COMM/g' bws.txt ").read()
os.remove('log1.txt')

os.popen("cat eip.txt ecs.txt  db.txt redis.txt bws.txt > bill.txt ").read()
##### 分析获取到的 txt
print "WCR"
WCR_ecs = os.popen("awk   '{print $1}' ecs.txt | grep WCR | wc  -l ").read()
WCR_eip = os.popen("awk   '{print $1}' eip.txt | grep WCR | wc  -l ").read()
WCR_db = os.popen("awk   '{print $1}' db.txt | grep WCR | wc  -l ").read()
WCR_redis = os.popen("awk   '{print $1}' redis.txt | grep WCR | wc  -l ").read()
WCR_bws = os.popen("awk   '{print $1}' bws.txt | grep WCR | wc  -l ").read()
WCR_bill = os.popen("grep WCR bill.txt | awk '{print $2}' |  awk 'BEGIN{sum=0}{sum+=$1}END{print sum}' ").read()

print "JFM"
JFM_ecs = os.popen("awk   '{print $1}' ecs.txt | grep JFM | wc  -l ").read()
JFM_eip = os.popen("awk   '{print $1}' eip.txt | grep JFM | wc  -l ").read()
JFM_db = os.popen("awk   '{print $1}' db.txt | grep JFM | wc  -l ").read()
JFM_redis = os.popen("awk   '{print $1}' redis.txt | grep JFM | wc  -l ").read()
JFM_bws = os.popen("awk   '{print $1}' bws.txt | grep JFM | wc  -l ").read()
JFM_bill = os.popen("grep JFM bill.txt | awk '{print $2}' |  awk 'BEGIN{sum=0}{sum+=$1}END{print sum}' ").read()

print "TLLY"
TLLY_ecs = os.popen("awk   '{print $1}' ecs.txt | grep TLLY | wc  -l ").read()
TLLY_eip = os.popen("awk   '{print $1}' eip.txt | grep TLLY | wc  -l ").read()
TLLY_db = os.popen("awk   '{print $1}' db.txt | grep TLLY | wc  -l ").read()
TLLY_redis = os.popen("awk   '{print $1}' redis.txt | grep TLLY | wc  -l ").read()
TLLY_bws = os.popen("awk   '{print $1}' bws.txt | grep TLLY | wc  -l ").read()
TLLY_bill = os.popen("grep TLLY bill.txt | awk '{print $2}' |  awk 'BEGIN{sum=0}{sum+=$1}END{print sum}' ").read()

print "skyrun"
skyrun_ecs = os.popen("awk   '{print $1}' ecs.txt | grep skyrun | wc  -l ").read()
skyrun_eip = os.popen("awk   '{print $1}' eip.txt | grep skyrun | wc  -l ").read()
skyrun_db = os.popen("awk   '{print $1}' db.txt | grep skyrun | wc  -l ").read()
skyrun_redis = os.popen("awk   '{print $1}' redis.txt | grep skyrun | wc  -l ").read()
skyrun_bws = os.popen("awk   '{print $1}' bws.txt | grep skyrun | wc  -l ").read()
skyrun_bill = os.popen("grep skyrun bill.txt | awk '{print $2}' |  awk 'BEGIN{sum=0}{sum+=$1}END{print sum}' ").read()

print "COMM"
COMM_ecs = os.popen("awk   '{print $1}' ecs.txt | grep COMM | wc  -l ").read()
COMM_eip = os.popen("awk   '{print $1}' eip.txt | grep COMM | wc  -l ").read()
COMM_db = os.popen("awk   '{print $1}' db.txt | grep COMM | wc  -l ").read()
COMM_redis = os.popen("awk   '{print $1}' redis.txt | grep COMM | wc  -l ").read()
COMM_bws = os.popen("awk   '{print $1}' bws.txt | grep COMM | wc  -l ").read()
COMM_bill = os.popen("grep COMM bill.txt | awk '{print $2}' |  awk 'BEGIN{sum=0}{sum+=$1}END{print sum}' ").read()

print "CQB"
CQB_ecs = os.popen("awk   '{print $1}' ecs.txt | grep CQB | wc  -l ").read()
CQB_eip = os.popen("awk   '{print $1}' eip.txt | grep CQB | wc  -l ").read()
CQB_db = os.popen("awk   '{print $1}' db.txt | grep CQB | wc  -l ").read()
CQB_redis = os.popen("awk   '{print $1}' redis.txt | grep CQB | wc  -l ").read()
CQB_bws = os.popen("awk   '{print $1}' bws.txt | grep CQB | wc  -l ").read()
CQB_bill = os.popen("grep CQB bill.txt | awk '{print $2}' |  awk 'BEGIN{sum=0}{sum+=$1}END{print sum}' ").read()


print "ALL"
ALL_ecs = os.popen("cat  ecs.txt | wc  -l").read()
ALL_eip = os.popen("cat  eip.txt | wc  -l").read()
ALL_db = os.popen("cat  db.txt | wc  -l").read()
ALL_redis = os.popen("cat  redis.txt | wc  -l").read()
ALL_bws = os.popen("cat  bws.txt | wc  -l").read()
ALL_bill = os.popen("awk '{print $2}' bill.txt|  awk 'BEGIN{sum=0}{sum+=$1}END{print sum}' ").read()

####  excel
workbook = xlsxwriter.Workbook('金山云月账单.xlsx')
worksheet = workbook.add_worksheet('ksyun_bill')
worksheet.set_column('A:G',10)

title = [u'项目',u'服务器',u'弹性ip',u'数据库',u'redis',u'共享带宽',u'项目金额']
buname = [u'WCR',u'JFM',u'TLLY',u'skyrun',u'COMM',u'CQB',u'ALL']

data = [
    [WCR_ecs,WCR_eip,WCR_db,WCR_redis,WCR_bws,WCR_bill],
    [JFM_ecs,JFM_eip,JFM_db,JFM_redis,JFM_bws,JFM_bill],
    [TLLY_ecs,TLLY_eip,TLLY_db,TLLY_redis,TLLY_bws,TLLY_bill],
    [skyrun_ecs,skyrun_eip,skyrun_db,skyrun_redis,skyrun_bws,skyrun_bill],
    [COMM_ecs,COMM_eip,COMM_db,COMM_redis,COMM_bws,COMM_bill],
    [CQB_ecs,CQB_eip,CQB_db,CQB_redis,CQB_bws,CQB_bill],
    [ALL_ecs,ALL_eip,ALL_db,ALL_redis,ALL_bws,ALL_bill],

]
format=workbook.add_format()
format.set_border(1)

format_title=workbook.add_format()
format_title.set_border(1)
format_title.set_bg_color('#cccccc')
format_title.set_align('center')
format_title.set_bold()

format_ave=workbook.add_format()
format_ave.set_border(1)
format_ave.set_num_format('0.00')

worksheet.write_row('A1',title,format_title)
worksheet.write_column('A2', buname,format)
worksheet.write_row('B2', data[0],format)
worksheet.write_row('B3', data[1],format)
worksheet.write_row('B4', data[2],format)
worksheet.write_row('B5', data[3],format)
worksheet.write_row('B6', data[4],format)
worksheet.write_row('B7', data[5],format)
worksheet.write_row('B8', data[6],format)
workbook.close()



