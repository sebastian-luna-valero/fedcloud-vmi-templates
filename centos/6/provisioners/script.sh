#!/usr/bin/env bash

# add EPEL repository
yum -y install epel-release
# update already installed packages
yum -y update
# install new packages
yum -y install cloud-init cloud-utils-growpart


# set cloud-init to start after boot
chkconfig on cloud-init-local
chkconfig on cloud-init
chkconfig on cloud-config
chkconfig on cloud-final

# move configuration files to their right place
mv /root/sshd_config /etc/ssh/sshd_config
mv /root/cloud.cfg /etc/cloud/cloud.cfg

# remove ssh keys
rm -f /etc/ssh/ssh_host_*

# remove hardware address (MAC) and UUID from NIC configuration files
sed -i '/^HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-eth*
sed -i '/^UUID/d' /etc/sysconfig/network-scripts/ifcfg-eth*

# make sure nothing is messing with NICs' MAC adresses
unlink /etc/udev/rules.d/70-persistent-net.rules
ln -s /dev/null /etc/udev/rules.d/70-persistent-net.rules
unlink /etc/udev/rules.d/70-persistent-cd.rules
ln -s /dev/null /etc/udev/rules.d/70-persistent-cd.rules

chkconfig network on

# look root password
passwd -l root

# clean bash history and cloud init logs
rm -f ~/.bash_history
rm -f /var/log/cloud-init*