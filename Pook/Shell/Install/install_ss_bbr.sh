wget http://ftp.gnu.org/gnu/glibc/glibc-2.15.tar.gz
wget http://ftp.gnu.org/gnu/glibc/glibc-ports-2.15.tar.gz
tar -zxf glibc-2.15.tar.gz
tar -zxf glibc-ports-2.15.tar.gz
mv glibc-ports-2.15 glibc-2.15/ports
mkdir glibc-build-2.15
cd glibc-build-2.15
../glibc-2.15/configure --prefix=/usr --disable-profile --enable-add-ons --with-headers=/usr/include --with-binutils=/usr/bin
make all && make install

ldd --version


wget https://raw.githubusercontent.com/kuoruan/shell-scripts/master/ovz-bbr/ovz-bbr-installer.sh
chmod +x ovz-bbr-installer.sh
./ovz-bbr-installer.sh

