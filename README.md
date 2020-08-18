# Create VMs for hosting a Kubernetes cluster

## 1. Introduction

Before installing a Kubenretes cluster, we need to install the VMs first.
We will use Vagrant to install those machines using libvirt.

## 2. Architecture

![Architecture](https://github.com/saubriot/k8s_vagrant/blob/master/images/k8s_architecture.png)

## 3. Pre requisites
- A strong computer with at least 8 vCPUs and 16GB RAM
- Libvirt installed 
- Vagrant installed to deploy and configure debian "buster" VMs using Libvirt

## 4. Create VMs using Libvirt

Move to vagrant/libvirt/demo directory (assuming git repo is installed in ~/k8s_vagrant) and create the VM "strasbourg.europe" using "vagrant up" (moving up).
Note : you password will be prompted for sudo operation.
```
cd ~/k8s_vagrant/vagrant/libvirt/demo
vagrant up strasbourg.europe
[sudo] Password for xxxxx :
```
Allow transparent ssh for user vagrant for VM "strasbourg.europe" :
```
./ssh_allow_host.sh strasbourg.europe 192.168.10.254
[strasbourg.europe - 192.168.10.254] Added certificate
```
Now you are able to connect the VM using vagrant account :
```
ssh vagrant@192.168.10.254
$uname -a
Linux buster 4.19.0.8-amd64 #1 SMP Debian 4.19.98-1 (2020-01-26) x86_64 GNU/Linux
```
Reproduce the operation for VMs paris.europe, roma.europe, madrid.europe and lisboa.europe :
```
vagrant up paris.europe
vagrant up roma.europe
vagrant up madrid.europe
vagrant up lisboa.europe
./ssh_allow_host.sh paris.europe 192.168.10.10
./ssh_allow_host.sh roma.europe 192.168.10.12
./ssh_allow_host.sh madrid.europe 192.168.10.13
./ssh_allow_host.sh lisboa.europe 192.168.10.14
ssh vagrant@192.168.10.10 "echo Hello World !"
ssh vagrant@192.168.10.12 "echo Hello World !"
ssh vagrant@192.168.10.13 "echo Hello World !"
ssh vagrant@192.168.10.14 "echo Hello World !"
```
Now all the VMs are up and running.
If you want to stop the VMs :
```
vagrant halt -f
```
or just one VM :
```
vagrant halt strasbourg.europe -f
```
If you want to start the VMs :
```
vagrant up
```
or just one VM :
```
vagrant up strasbourg.europe
```
If you want to destroy the VMs :
```
vagrant destroy -f
```
or just one VM :
```
vagrant destroy strasbourg.europe -f
```
If you want to destroy the bridged network (by default demo0) :
```
sudo virsh net-destroy demo0
```
If you want to remove ssh known hosts :
```
ssh-keygen -f ~/.ssh/known_hosts -R "192.168.10.254"
ssh-keygen -f ~/.ssh/known_hosts -R "192.168.10.10"
ssh-keygen -f ~/.ssh/known_hosts -R "192.168.10.12"
ssh-keygen -f ~/.ssh/known_hosts -R "192.168.10.13"
ssh-keygen -f ~/.ssh/known_hosts -R "192.168.10.14"
```
So if you want to clean up everything :
```
vagrant destroy -f
sudo virsh net-destroy demo0
ssh-keygen -f ~/.ssh/known_hosts -R "192.168.10.254"
ssh-keygen -f ~/.ssh/known_hosts -R "192.168.10.10"
ssh-keygen -f ~/.ssh/known_hosts -R "192.168.10.12"
ssh-keygen -f ~/.ssh/known_hosts -R "192.168.10.13"
ssh-keygen -f ~/.ssh/known_hosts -R "192.168.10.14"
```



