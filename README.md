#### 用于数据同步，包括但不限于一种方法

` 备选方案：cp、scp、dump、cpio、dd、rsync、ftp`

#### 场景描述
```
主要处理大数据场景下的数据备份
```

##### rsync  已经过centos多机实测
* 安装方法： 本实例时没有selinux、firewalld的脚本
一、服务端设置及关键点
```
1\ rsync主要用于网络环境下的文件同步，有服务端和客户端，可以单向或双向对考，
2\ 下载后，首先安装服务端：inSer.sh  本方法是使用tar包安装
3\ 然后在客户端执行yum -y install rsync
4\ inCli.sh主要适用于没有网络环境的情况无法下载tar包且本地没有tar包时使用，本脚本不要与inSer.sh在一台机器使用，除非通宵rsync了
```

#### rsync常见故障排查方法：
```
http://www.bubuko.com/infodetail-2025163.html
```

####  使用方法参照：
```
1、 编写rsync.conf配置文件
# vi /etc/rsyncd.conf
内容如下：
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
 
注释：
port  #开放端口
uid = nobody  #进行备份的用户UID，nobody为任何用户
gid = nobody  #进行备份的组GID，nobody为任意组
use chroot = no  #如果"use chroot"指定为true，那么rsync在传输文件以前首先chroot到path参数所指定的目录下。这样做的原因是实现额外的安全防护，但是缺 点是需要以root权限，并且不能备份指向外部的符号连接所指向的目录文件。默认情况下chroot值为true。但是这个一般不需要，所以我选择no或 false
list = no  #不允许列清单
max connections = 200 #最大连接数
timeout = 600 #覆盖客户指定的IP超时时间，也就是说rsync服务器不会永远等待一个崩溃的客户端。
pidfile = /var/run/rsyncd.pid  #pid文件的存放位置
lock file = /var/run/rsync.lock  #锁文件的存放位置
log file = /var/log/rsyncd.log  #日志文件的存放位置
 
[backup]  #这里是认证模块名，即跟samba语法一样，是对外公布的名字
path = /var/log  #这里是参与同步的目录
ignore errors  #可以忽略一些无关的IO错误
read only = no  #允许可读可写
list = no  #不允许列清单
hosts allow = 192.168.1.0/255.255.255.0  #这里跟samba的语法是一样的，只允许192.168.1.0/24的网段进行同步，拒绝其它一切IP
auth users = admin  #认证的用户名
secrets file = /etc/rsyncd.secrets  #密码文件存放地址
 
注意：对于这个地方的配置文件，虽然解释的很清楚，可是一些朋友始终还会在这里出错，这里我提亮点易错点：
[backup]是认证模块名和 path = /var/www 是参与同步的目录
这里的path 大家要记好了，这里不要随便的一设置就直接完事，要知道这里是认证模块的，以后从客户机备份的数据会存储在这里。
 
2、编写用户密码文件
echo 'pic:pic999'  > /etc/rsync.pas  #用户名:密碼

chmod 600 /etc/rsync.pas
chmod 755 -R /usr/local 
useradd nobody:nobody
 
3、给予只读权限
$ mkdir -pv /var/log/
$ chown -R nobody:nobody /var/log
 
4、启动服务
$ [/usr/local/rsync/bin/]rsync --daemon  --config=/etc/rsyncd.conf
 
5、加入开机自启动
$ echo "rsync --daemon">> /etc/rc.local
 
二、Linux客户端进行同步
1、客户端默认好像已经装了rsync，没有的话装下（本处可以yum安装，没有yum的参照inCli.sh文件）：
yum -y install rsync
 
2、创建密码文件
$ vi /etc/rsyncC.pas
文件内容如下(只包含密码部分)：
123456789
 
3、执行异步同步操作：
$ /usr/bin/rsync -avz --progress --password-file=/etc/rsyncd.passwdroot@192.168.1.1::log /home/log


```