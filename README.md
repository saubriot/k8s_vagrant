# Create VMs for hosting a Kubernetes cluster

## 1. Introduction

Before installing a Kubenretes cluster, we need to install the VMs first.
We will use Vagrant to install those machines using libvirt.

## 2. Architecture

| Host              | IP Address     | Admin  | Etcd        | Single Master | Multi Master | Worker |
|-------------------|----------------|--------|-------------|---------------|--------------|--------|
| strasbourg.europe | 192.168.20.141 | always |             |               |              |        |
| paris.europe      | 192.168.20.52  |        | always      | always        | initial      |        |
| berlin.europe     | 192.168.20.55  |        | when master |               | join         |        |
| roma.europe       | 192.168.20.67  |        | when master |               | join         |        |
| lisboa.europe     | 192.168.20.91  |        |             |               |              | always |
| madrid.europe     | 192.168.20.92  |        |             |               |              | always |
| amsterdam.europe  | 192.168.20.93  |        |             |               |              | always |


## 3. Pre requisites
- A strong computer with at least 8 vCPUs and 16GB RAM
- Libvirt installed 
- Vagrant installed to deploy and configure debian "buster" VMs using Libvirt

### 3.1 Libvirt change default network settings

Before moving one, we have to change the default network in libvirt.  
Why ? Because of a problem during etcd installation. Etcd was not listening on my subnet 192.168.20.0/24 but was binded to an other subnet.

```
virsh net-edit default
```
Change ip address and range to reflect our default network used in vagrant 192.168.20.0/24
```
<network>
  <name>default</name>
  <uuid>142e6412-86a4-4d44-8b15-833562417d29</uuid>
  <forward mode='nat'/>
  <bridge name='virbr0' stp='on' delay='0'/>
  <mac address='52:54:00:e4:48:bb'/>
  <ip address='192.168.20.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.20.2' end='192.168.20.254'/>
    </dhcp>
  </ip>
</network>
```

After this change we apply with :
```
virsh net-start default
```

A "ping paris" on the paris.europe host should produce 192.168.20.52


## 4. Create VMs

Move to vagrant/libvirt/demo directory (assuming git repo is installed in ~/k8s_vagrant) and create the VMs using "vagrant up" (moving up).
Note : you password will be prompted for sudo operation.
```
cd ~/k8s_vagrant/vagrant/libvirt/demo
vagrant up
[sudo] Password for xxxxx :
```
Allow transparent ssh for user vagrant for all VM  :
```
./ssh_allow_all.sh
```
Now you are able to connect the VM using vagrant account :
```
ssh vagrant@192.168.20.141
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
If you want to destroy all the VMs :
```
vagrant destroy -f
```
or just one VM :
```
vagrant destroy strasbourg.europe -f
```
