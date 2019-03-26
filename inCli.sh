#!/bin/bash
# # rsync tar包安装客户端

export srcIp=127.0.0.1
export srcLevPath=/var/log/anaconda
export descPath=/root/testsync/
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
#chmod 755 -R /usr/local

# sync 方法
#example
#/usr/bin/rsync -avzP --delete --password-file=/etc/rsync.pas pic@$127.0.0.1::tools /rsync/

/usr/local/rsync/bin/rsync -avzP --delete --password-file=/etc/rsyncC.pas pic@${srcIp}::${srcLevPath}  ${descPath}

# 常见故障参考
## http://www.bubuko.com/infodetail-2025163.html