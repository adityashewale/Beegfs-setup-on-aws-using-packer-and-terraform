#!/usr/bin/env bash


# Setup sudo to allow no-password sudo for "hashicorp" group and adding "terraform" user
sudo groupadd -r hashicorp
sudo useradd -m -s /bin/bash terraform
sudo usermod -a -G hashicorp terraform
sudo cp /etc/sudoers /etc/sudoers.orig
echo "terraform ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/terraform

# Installing SSH key

sudo mkdir -p /home/terraform/.ssh
sudo chmod 700 /home/terraform/.ssh
sudo cp /tmp/tf-packer.pub /home/terraform/.ssh/authorized_keys
sudo chmod 600 /home/terraform/.ssh/authorized_keys
sudo chown -R terraform /home/terraform/.ssh
sudo usermod --shell /bin/bash terraform


#sudo -H -i -u terraform -- env bash << EOF














sudo getenforce

sudo    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g'  /etc/selinux/config

sudo cat /etc/selinux/config
#sudo init 6
#sudo setenforce 0 
sudo setenforce 0
sudo sestatus 
sudo getenforce
sudo cat /etc/selinux/config
#sudo systemctl stop firewalld 

#hostn=`hostname` 



#echo "beegfs-server-client" > /etc/hostname
#echo "127.0.0.1 `hostname`" >> /etc/hosts 


lsblk

df -h 

sudo hostname > hostnameis

#####creating repo file and copy into /etc/yum.repos##########

sudo cat <<EOT > b.repo
[beegfs]
name=BeeGFS 7.2 (rhel7)

# If you have an active BeeGFS support contract, use the alternative URL below
# to retrieve early updates. Replace username/password with your account for
# the BeeGFS customer login area.
#baseurl=https://username:password@www.beegfs.io/login/release/beegfs_7.2/dists/rhel7
baseurl=https://www.beegfs.io/release/beegfs_7.2/dists/rhel7

gpgkey=https://www.beegfs.io/release/beegfs_7.2/gpg/RPM-GPG-KEY-beegfs
gpgcheck=0
enabled=1




EOT

sudo cp b.repo /etc/yum.repos.d/


sudo yum clean all
sudo yum repolist
######################### installing  beegfs and required packges #############################
sudo yum install -y  wget 


sudo wget ftp://ftp.pbone.net/mirror/ftp.scientificlinux.org/linux/scientific/7.0/x86_64/updates/security/kernel-devel-3.10.0-862.2.3.el7.x86_64.rpm

ls -lrth 

sudo yum install -y kernel-devel-3.10.0-862.2.3.el7.x86_64.rpm



sudo  wget http://linuxsoft.cern.ch/cern/centos/7/updates/x86_64/Packages/kernel-headers-3.10.0-862.2.3.el7.x86_64.rpm

ls -lrth 

sudo yum install -y kernel-headers-3.10.0-862.2.3.el7.x86_64.rpm

sudo yum -y install wget  beegfs-mgmtd  beegfs-meta  beegfs-storage beegfs-client beegfs-helperd beegfs-utils




sudo mkdir /meta-data
sudo mkdir /storage1
sudo mkdir /storage2


sudo mkfs.ext4 /dev/xvdc 
sudo mkfs.ext4 /dev/xvdd 
sudo mkfs.ext4 /dev/xvde


sudo mount /dev/xvdc /meta-data
sudo mount /dev/xvdd /storage1
sudo mount /dev/xvde /storage2

sudo echo "/dev/xvdc /meta-data                       ext4    defaults        1 1" >> /etc/fstab

sudo echo "/dev/xvdd /storage1                       ext4    defaults        1 1" >> /etc/fstab

sudo echo "/dev/xvde /storage2                      ext4    defaults        1 1" >> /etc/fstab

sudo mkdir -p /mgmt/beegfs/beegfs_mgmtd
sudo mkdir -p /meta-data/beegfs/beegfs_meta
sudo mkdir -p /storage1/beegfs_storage1
sudo mkdir -p /storage2/beegfs_storage2



df -h

sudo /opt/beegfs/sbin/beegfs-setup-mgmtd -p /data/beegfs/beegfs_mgmtd
sudo /opt/beegfs/sbin/beegfs-setup-meta -p /meta-data/beegfs/beegfs_meta -s 2 -m localhost
sudo /opt/beegfs/sbin/beegfs-setup-storage -p /storage1/beegfs_storage -s 3 -i 201 -m localhost
sudo /opt/beegfs/sbin/beegfs-setup-storage -p /storage2/beegfs_storage -s 3 -i 202 

sudo /opt/beegfs/sbin/beegfs-setup-client -m localhost

sudo systemctl start beegfs-mgmtd
sudo systemctl status beegfs-mgmtd
sudo systemctl start beegfs-meta

sudo systemctl status beegfs-meta

sudo systemctl start beegfs-storage

sudo systemctl status beegfs-storage

sudo systemctl start beegfs-helperd

sudo systemctl status beegfs-helperd
sudo systemctl start beegfs-client

sudo systemctl status  beegfs-client

sudo systemctl enable beegfs-mgmtd beegfs-meta beegfs-storage beegfs-helperd  beegfs-client


df -h

lsblk 

echo "done"

sudo getent  passwd | grep terraform




