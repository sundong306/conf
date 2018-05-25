cd  /tmp ;  wget https://openresty.org/download/openresty-1.11.2.5.tar.gz
apt-get install libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl make build-essential
tar -zxvf openresty-1.11.2.5.tar.gz
cd openresty-1.11.2.5
./configure --prefix=/opt/openresty --with-luajit --without-http_redis2_module --with-http_iconv_module
make  && make install
cd /opt/openresty/nginx/conf ; rm -rf nginx.conf
wget https://raw.githubusercontent.com/sundong306/conf/master/Dsky/AOA/nginx.conf
cd /opt/openresty/nginx
svn co  svn://111.231.102.162/project/aoa_root/hk_publish/web/battle_lua_server/work
/opt/openresty/nginx/sbin/nginx  -t
