#!/bin/bash
# # rsync tar包安装客户端

set -e
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


# config

echo 'pic999'  > /etc/rsyncC.pas

chmod 600 /etc/rsyncC.pas


# sync 方法
#example
#从服务端拉取：  rsync --password-file=/etc/rsync.pas pic@10.211.55.7::pull_name /tmp/etc/ -avzPr --progress     //注意：采用daemon模式时，源目录没有斜杠/时仅是将该目录下文件拉取过来，并不会将该目录拉取过来，与local模式不同
#客户端 推送到服务端： rsync --password-file=/etc/rsync.pas /root/anaconda-ks.cfg pic@10.211.55.7::push_name/  -avzPr --progress

# 常见故障参考
## http://www.bubuko.com/infodetail-2025163.html