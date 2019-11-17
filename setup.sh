yum -y upgrade
yum -y install bind-utils net-tools epel-release jq ntp

# Configure OS
systemctl stop chronyd
systemctl disable chronyd
systemctl start ntpd
systemctl enable ntpd

systemctl disable NetworkManager.service
systemctl stop NetworkManager.service

systemctl disable firewalld
systemctl stop firewalld