#!/bin/bash
#https://jalena.bcsytv.com/archives/1225
#环境检查
	
ldd /usr/sbin/sshd|grep libwrap　　//查看libwrap动态链接库文件。
#libwrap.so.0 => /lib64/libwrap.so.0 (0x00007f4b2a1b9000)
 python -V
 #　　　　　　　　　　　　  //查询版本为2.6.5
#Python 2.6.6

#安装步骤

cd /usr/src 
wget http://ncu.dl.sourceforge.net/sourceforge/denyhosts/DenyHosts-2.6.tar.gz
tar -xzvf DenyHosts-2.6.tar.gz
cd DenyHosts-2.6
python setup.py install　　 
# //安装Denyhost
cd /usr/share/denyhosts/   
# //切换目录进入/usr/share/denyhosts目录
cp denyhosts.cfg-dist denyhosts.cfg  
# //备份配置文件

 #DenyHosts参数配置

	
SECURE_LOG = /var/log/secure
# format is: i[dhwmy]
# Where i is an integer (eg. 7)
# m = minutes
# h = hours
# d = days
# w = weeks
# y = years
#
# never purge:
# PURGE_DENY=50m
# HOSTS_DENY=/etc/hosts.deny
# BLOCK_SERVICE=sshd
# DENY_THRESHOLD_INVALID=1
# DENY_THRESHOLD_VALID=10
# DENY_THRESHOLD_ROOT=5
# WORK_DIR=/usr/local/share/denyhosts/data
# DENY_THRESHOLD_RESTRICTED =1
# LOCK_FILE=/var/lock/subsys/denyhosts
# HOSTNAME_LOOKUP=NO
# ADMIN_EMAIL = bcsytv@gmail.com
# SMTP_HOST = localhost
# SMTP_PORT = 25
# SMTP_FROM = jalena <bcsytv@gmail.com>
# SMTP_SUBJECT = DenyHosts Daily Report
# DAEMON_LOG=/var/log/denyhosts
# DAEMON_PURGE=10m

 # DenyHosts启动文件配置
cp daemon-control-dist daemon-control
chown root daemon-control
chmod 700 daemon-control
./daemon-control start       
#  //启动DenyHosts
 ln -s /usr/share/denyhosts/daemon-control /etc/init.d/denyhosts
   # //建立符号链接
chkconfig --add denyhosts
　　　　　　　　　　　　　　　　 # //增加denyhosts服务进程
chkconfig  denyhosts on　　　　　　　　　　　　　　　　　　　　　
#//设置开机启动denyhosts
chkconfig --list denyhosts
#      // 查看是否生效

#至此基本就好了，接下来就看看你的异常日志吧
tail -f /var/log/secure 