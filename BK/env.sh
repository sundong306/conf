echo -e "\033[31m 注意：token_secret一定要做修改，防止网站被攻击!!!!!!! \033[0m"
echo -e "\033[32m 注意：token_secret一定要做修改，防止网站被攻击!!!!!!! \033[0m"
echo -e "\033[33m 注意：token_secret一定要做修改，防止网站被攻击!!!!!!! \033[0m"




#部署的IP地址
export LOCALHOST_IP="10.10.10.12"

#设置你的MYSQL密码
export MYSQL_PASSWORD="m9uSFL7duAVXfeAwGUSG"

### 设置你的redis密码
export REDIS_PASSWORD="cWCVKJ7ZHUK12mVbivUf"

### RabbitMQ用户密码信息
export MQ_USER="ss"
export MQ_PASSWORD="5Q2ajBHRT2lFJjnvaU0g"


#codo-admin用到的cookie和token
export cookie_secret="nJ2oZis0V/xlArY2rzpIE6ioC9/KlqR2fd59sD=UXZJ=3OeROB"
# 这里codo-admin和gw网关都会用到，一定要修改。可生成随意字符
export token_secret="pXFb4i%*834gfdh963df718iodGq4dsafsdadg7yI6ImF1999aaG7"


##如果要进行读写分离，Master-slave主从请自行建立，一般情况下都是只用一个数据库就可以了
# 写数据库
export DEFAULT_DB_DBHOST="10.10.10.12"
export DEFAULT_DB_DBPORT='3306'
export DEFAULT_DB_DBUSER='codo'
export DEFAULT_DB_DBPWD=${MYSQL_PASSWORD}
#export DEFAULT_DB_DBNAME=${mysql_database}

# 读数据库
export READONLY_DB_DBHOST='10.10.10.12'
export READONLY_DB_DBPORT='3306'
export READONLY_DB_DBUSER='codo'
export READONLY_DB_DBPWD=${MYSQL_PASSWORD}
#export READONLY_DB_DBNAME=${mysql_database}

# 消息队列
export DEFAULT_MQ_ADDR='10.10.10.12'
export DEFAULT_MQ_USER=${MQ_USER}
export DEFAULT_MQ_PWD=${MQ_PASSWORD}

# 缓存
export DEFAULT_REDIS_HOST='10.10.10.12'
export DEFAULT_REDIS_PORT=6379
export DEFAULT_REDIS_PASSWORD=${REDIS_PASSWORD}
