#!/bin/bash
sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
setenforce 0
dnf install -y gcc glibc glibc-common perl httpd php wget gd gd-devel
dnf install openssl-devel -y
cd /tmp
wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.6.tar.gz
tar xzf nagioscore.tar.gz
cd /tmp/nagioscore-nagios-4.4.6/
./configure
make all
make install-groups-users
usermod -a -G nagios apache
make install
make install-daemoninit
systemctl enable --now httpd.service
make install-commandmode
make install-config
make install-webconf
htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin redhat
systemctl restart httpd.service
systemctl enable --now nagios.service

