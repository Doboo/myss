#!/bin/bash
function checkos(){
    if [ -f /etc/redhat-release ];then
        OS=centos
    elif [ ! -z "`cat /etc/issue | grep bian`" ];then
        OS=debian
    elif [ ! -z "`cat /etc/issue | grep Ubuntu`" ];then
        OS=ubuntu
    else
        echo "Unsupported operating systems!"
        exit 1
    fi
	echo $OS
}
#检查是否是root用户
if [[ $(id -u) != "0" ]]; then
    printf "\e[42m\e[31mError: You must be root to run this install script.\e[0m\n"
    exit 1
fi

printf "
####################################################
# This is a shadowsocks-python  install program for centos6  && debian7               
# Version: 1.2.                                   
# Author: aboutss QQ:38196962                          
# # Thanks to AnonymousV:http://shadowsocks.blogspot.tw/2015/01/shadowsocks.html                                                               #
####################################################
"
echo "Press Enter to continue"
read num
#判断操作系统
checkos
if [ $OS = "ubuntu" ]; then
    echo " Install  ubuntu wget ..."
	apt-get -y install wget
fi
if [ $OS = "debian" ]; then
	apt-get update -y
	apt-get  install python-setuptools m2crypto supervisor -y
	apt-get install denyhosts -y
	easy_install pip  
pip install shadowsocks

fi
if [ $OS = "centos" ]; then
	yum install epel-release -y
	yum update -y
	yum install python-setuptools m2crypto supervisor -y
	easy_install pip  
	pip install shadowsocks
fi

#config setting
echo "#############################################################"
echo "#"
echo "# Please input your shadowsocks-python server_port and password"
echo "#"
echo "#############################################################"
echo ""
echo "input server_port:"
read sspyserverport
echo "input password:"
read sspypwd
 
# Config shadowsocks
   cat << _EOF_ >/etc/shadowsocks.json
{
    "server":"0.0.0.0",
    "server_port":${sspyserverport},
    "local_port":1080,
    "password":"${sspypwd}",
    "timeout":120,
    "method":"aes-256-cfb"
}
_EOF_

#设置开机启动
if [ $OS = "ubuntu" ]; then
			echo " Install  ubuntu wget ..."
			apt-get -y install wget
fi
if [ $OS = "debian" ]; then
	#用supervisord守护进程启动程序
	 echo "[program:shadowsocks]" >> /etc/supervisor/supervisord.conf
	 echo "command=ssserver -c /etc/shadowsocks.json" >> /etc/supervisor/supervisord.conf
	 echo "autostart=true" >> /etc/supervisor/supervisord.conf
	 echo "autorestart=true" >> /etc/supervisor/supervisord.conf
	 echo "user=root" >> /etc/supervisor/supervisord.conf
	
	 	 echo "redirect_stderr=true" >> /etc/supervisor/supervisord.conf
	 #将程序输出重定向到该文件
	 echo "stdout_logfile=/var/log/shadowsocks.log" >> /etc/supervisor/supervisord.conf
	 #将程序错误信息重定向到该文件
	 echo "stderr_logfile=/var/log/shadowsocks-err.log" >> /etc/supervisor/supervisord.conf
	  #通过网页访问日志
	 echo "[inet_http_server]" >> /etc/supervisor/supervisord.conf
	 #IP和绑定端口
	 echo "port = 0.0.0.0:9001" >> /etc/supervisor/supervisord.conf
	 #管理员名称
	 echo "username = admin" >> /etc/supervisor/supervisord.conf
	 #管理员密码
     echo "password = 111111" >> /etc/supervisor/supervisord.conf
fi
if [ $OS = "centos" ]; then
	#用supervisord守护进程启动程序
	chkconfig --levels 235 supervisord on
	 echo "[program:shadowsocks]" >> /etc/supervisord.conf
	 echo "command=ssserver -c /etc/shadowsocks.json" >> /etc/supervisord.conf
	 echo "autostart=true" >> /etc/supervisord.conf
	 echo "autorestart=true" >> /etc/supervisord.conf
	 echo "user=root" >> /etc/supervisord.conf
	  echo "log_stderr=true" >> /etc/supervisord.conf
	 echo "logfile=/var/log/shadowsocks.log" >> /etc/supervisord.conf

fi
#安装完成
echo ""
echo -e "============================="
echo -e "Shadowsocks-python has install completed!"
echo -e "Your Server Port: ${sspyserverport}"
echo -e "Your Password: ${sspypwd}"
echo -e "Your Encryption Method:aes-256-cfb"
echo -e "==============================="
echo "Press Enter to reboot the system"
read num
reboot
