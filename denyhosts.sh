#!/bin/bash
#https://jalena.bcsytv.com/archives/1225
#�������
	
ldd /usr/sbin/sshd|grep libwrap����//�鿴libwrap��̬���ӿ��ļ���
#libwrap.so.0 => /lib64/libwrap.so.0 (0x00007f4b2a1b9000)
 python -V
 #������������������������  //��ѯ�汾Ϊ2.6.5
#Python 2.6.6

#��װ����

cd /usr/src 
wget http://ncu.dl.sourceforge.net/sourceforge/denyhosts/DenyHosts-2.6.tar.gz
tar -xzvf DenyHosts-2.6.tar.gz
cd DenyHosts-2.6
python setup.py install���� 
# //��װDenyhost
cd /usr/share/denyhosts/   
# //�л�Ŀ¼����/usr/share/denyhostsĿ¼
cp denyhosts.cfg-dist denyhosts.cfg  
# //���������ļ�

 #DenyHosts��������

	
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

 # DenyHosts�����ļ�����
cp daemon-control-dist daemon-control
chown root daemon-control
chmod 700 daemon-control
./daemon-control start       
#  //����DenyHosts
 ln -s /usr/share/denyhosts/daemon-control /etc/init.d/denyhosts
   # //������������
chkconfig --add denyhosts
�������������������������������� # //����denyhosts�������
chkconfig  denyhosts on������������������������������������������
#//���ÿ�������denyhosts
chkconfig --list denyhosts
#      // �鿴�Ƿ���Ч

#���˻����ͺ��ˣ��������Ϳ�������쳣��־��
tail -f /var/log/secure 