#!/bin/bash

# rsync tar包安装服务端，系统需要有rpm源gcc、c++、perl
set -e
export descIp=127.0.0.1
export srcPath=/var/log/
# install rsync
yum -y install gcc gcc-c++ perl

inpath=$(find / -name installSync)
echo ${inpath}
cd ${inpath}
a=$(ls rsync-3.0.8.tar.gz)
if [[ $a==rsync-3.0.8.tar.gz ]]; then
	tar -xzf rsync-3.0.8.tar.gz&&cd rsync-3.0.8 
	./configure --prefix=/usr/local/rsync
	make && make install
fi


# config Action:edit hosts allow
cat << EOF > /etc/rsyncd.conf
[global]
uid = nobody
gid = nobody
use chroot = no
max connections = 30
hosts allow = ${descIp}
pid file = /var/run/rsyncd.pid
log file = /var/log/rsyncd.log
lock file = /var/run/rsyncd.lock
transfer logging = yes
log fomat = %t %a %m %f %b
syslog facility = local3
timeout = 300

[pic]
read only = yes
path = ${srcPath}
comment = pic
auth users = pic
secrets file = /etc/rsync.pas
timeout = 300
EOF

echo 'pic:pic999'  > /etc/rsync.pas

chmod 600 /etc/rsync.pas
chmod 755 -R /usr/local

# start
/usr/local/rsync/bin/rsync  --daemon
sleep 1
rsync_serv_info=$(ss -tunlp |grep rsync)
echo 'rsync service port : ' ${rsync_serv_info}




