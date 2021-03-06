#!/bin/bash

# rsync tar包安装服务端，系统需要有rpm源gcc、c++、perl
# 注意：脚本在使用时需要将变量descIp、srcPath、pushPath替换成自己的场景valvue。
set -e
export descIp=10.211.55.0/24     # 接收客户端ip
export syncSrcPath=/etc/			# 需要同步給客户端的目录
export pushPath=/tmp/				# 需要接受客户端push到服务端的文件目录
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
max connections = 20
hosts allow = ${descIp}
pid file = /var/run/rsyncd.pid
log file = /var/log/rsyncd.log
lock file = /var/run/rsyncd.lock
transfer logging = yes
log fomat = %t %a %m %f %b
timeout = 300

[synced_name]
read only = yes
path = ${syncSrcPath}
auth users = pic
secrets file = /etc/rsyncd.pwd
timeout = 300

[push_name]
read only = no
write only = yes
path = ${pushPath}
auth users = pic
secrets file = /etc/rsyncd.pwd
timeout = 300
EOF

echo 'pic:pic999'  > /etc/rsyncd.pwd

chmod 600 /etc/rsyncd.pwd
ln -sv /usr/local/rsync/bin/rsync /usr/bin/

# start
/usr/local/rsync/bin/rsync  --daemon  --config=/etc/rsyncd.conf
sleep 1
rsync_serv_info=$(ss -tunlp |grep rsync)
echo 'rsync service INFO : ' ${rsync_serv_info}

# get rsyncd pid and sed rsyncd-conf then restart


