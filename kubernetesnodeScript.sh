#!/bin/bash

    #Author : Yaovi
    #Date : 4/2/22

## ---------- script install kubernetes on the node -----------------

echo 'Set Hostnames'

hostnamectl set-hostname k8worker1

echo 'Edit /etc/hosts file'

cat << EOF >> /etc/hosts

192.168.0.40 k8smaster
192.168.0.41 k8sworker1
192.168.0.42 k8sworker2
EOF

echo 'Disable SELinux'

setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

echo 'Disable firewall and edit Iptables settings'

systemctl disable firewalld
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

echo 'Setup Kubernetes Repo'

cat << EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

echo 'Installing Kubeadm and Docker, Enable and start the services'

yum install kubeadm docker -y
systemctl enable kubelet
systemctl start kubelet
systemctl enable docker
systemctl start docker

echo 'Disable Swap'

swapoff -a
vi /etc/fstab and Comment the line with Swap Keyword
