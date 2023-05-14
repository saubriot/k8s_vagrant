#!/bin/bash

vm_host=$1
vm_ip=$2

echo ""
echo "allowing host : $vm_host $vm_ip"
echo "====================================================="


[ -f ~/.ssh/id_rsa.pub ] || ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ""

ssh-keygen -f ~/.ssh/known_hosts -R $vm_ip > /dev/null 2>&1

cat ~/.ssh/id_rsa.pub | \
	ssh -o "StrictHostKeyChecking=no" vagrant@$vm_ip \
	-i .vagrant/machines/$vm_host/virtualbox/private_key \
	"cat - >> ~/.ssh/authorized_keys" > /dev/null 2>&1

ssh vagrant@$vm_ip "echo Hello World $vm_host $vm_ip"

echo ""
