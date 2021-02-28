#!/usr/bin/env bash



# Installing SSH key

sudo mkdir -p /home/centos/.ssh
sudo chmod 700 /home/centos/.ssh
sudo cp /tmp/tf-packer.pub /home/centos/.ssh/authorized_keys
sudo chmod 600 /home/centos/.ssh/authorized_keys
sudo chown -R centos /home/centos/.ssh
sudo usermod --shell /bin/bash centos
sudo cp /etc/sudoers /etc/sudoers.orig
sudo echo "centos ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/centos


sudo getenforce

sudo    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g'  /etc/selinux/config

sudo cat /etc/selinux/config
sudo setenforce 0
sudo sestatus 
sudo getenforce
sudo cat /etc/selinux/config

#hostn=`hostname` 
sudo hostnamectl set-hostname beegfs


#echo "beegfs-server-client" > /etc/hostname
#echo "127.0.0.1 `hostname`" >> /etc/hosts 


lsblk

df -h 

#sudo hostname > hostnameis

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


##################### Installing reuired beegfs packges and dbench #######################################
sudo yum -y install wget  beegfs-mgmtd  beegfs-meta  beegfs-storage beegfs-client beegfs-helperd beegfs-utils dbench

############################Creating directory to mount storage#########################


sudo mkdir /meta-data
sudo mkdir /storage1
sudo mkdir /storage2

######################## Formating raw storage ################################
sudo mkfs.ext4 /dev/xvdc 
sudo mkfs.xfs /dev/xvdd 
sudo mkfs.xfs /dev/xvde

########################### Mounting raw storage ###############################################
sudo mount /dev/xvdc /meta-data
sudo mount /dev/xvdd /storage1
sudo mount /dev/xvde /storage2

sudo setfacl -m u:centos:rw /etc/rc.local

sleep 5 

sudo chmod +x /etc/rc.local
sudo systemctl enable rc-local
sudo echo "mount /dev/xvdc /meta-data" >> /etc/rc.local

sudo echo "mount /dev/xvdd /storage1" >> /etc/rc.local

sudo echo "mount /dev/xvde /storage2" >> /etc/rc.local

#sudo echo "sleep 10" >> /etc/rc.local
#sudo echo "/usr/bin/hostname `hostname`" >> /etc/rc.local
#sudo echo "hostname" > /etc/hostname 
sudo echo "sleep 30 " >> /etc/rc.local
sudo echo "hostnamectl set-hostname beegfs" >> /etc/rc.local



############################### Creating directory for beegfs###############################

sudo mkdir -p /mgmt/beegfs/beegfs_mgmtd
sudo mkdir -p /meta-data/beegfs/beegfs_meta
sudo mkdir -p /storage1/beegfs_storage1
sudo mkdir -p /storage2/beegfs_storage2


sudo /opt/beegfs/sbin/beegfs-setup-mgmtd -p /data/beegfs/beegfs_mgmtd beegfs
sudo /opt/beegfs/sbin/beegfs-setup-meta -p /meta-data/beegfs/beegfs_meta -s 2 -m beegfs
sudo /opt/beegfs/sbin/beegfs-setup-storage -p /storage1/beegfs_storage -s 3 -i 201 -m beegfs
sudo /opt/beegfs/sbin/beegfs-setup-storage -p /storage2/beegfs_storage -s 3 -i 202 

sudo /opt/beegfs/sbin/beegfs-setup-client -m beegfs

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

df -TH

sudo echo "systemctl start beegfs-mgmtd beegfs-meta beegfs-storage beegfs-helperd  beegfs-client" >> /etc/rc.local


sudo df -h

lsblk 

sudo wget http://www.iozone.org/src/current/iozone3_394.tar 

sudo mv iozone3_394.tar /mnt/beegfs 

#sudo tar -xvf /mnt/beegfs/iozone3_394.tar

#sudo cd /mnt/beegfs/iozone3_394/src/current/
#sudo make ; make linux 

sudo yum install epel-release -y 
sudo yum install dbench -y 












