#!/bin/bash

vm_host=$1
vm_host_ip=$2

vm_short_host=`echo $vm_host|cut -f1 -d"."`

# create certificate if not exists
[ -f ~/.ssh/id_rsa.pub ] || ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ""

for vm_ip in `grep "${vm_short_host}.vm.network \"private_network\", ip:" Vagrantfile|cut -f2 -d":"|sed 's/"//g'`; do
	if [ "$vm_ip" == "$vm_host_ip" ] || [ "$vm_host_ip" == "" ]; then
		# copy certificate key for ssh authorization 
		if [ `ssh -o "StrictHostKeyChecking=no" vagrant@$vm_ip \
			-i .vagrant/machines/$vm_host/virtualbox/private_key \
			"grep $USER@$HOSTNAME ~/.ssh/authorized_keys"|wc -l` -eq 0 ]; then
			cat ~/.ssh/id_rsa.pub | \
				ssh -o "StrictHostKeyChecking=no" vagrant@$vm_ip \
				-i .vagrant/machines/$vm_host/virtualbox/private_key \
				"cat - >> ~/.ssh/authorized_keys"
			echo "[$vm_host - $vm_ip] Added certificate"
		fi
	fi
done

if [[ `grep allow_world_readable_tmpfiles=true ~/.ansible/ansible.cfg|wc -l` -eq 0 ]]; then

cat << EOF > ~/.ansible/ansible.cfg
[defaults]
allow_world_readable_tmpfiles=true
EOF

fi

if [[ `grep ANSIBLE_CONFIG ~/.bash_profile|wc -l` -eq 0 ]]; then
cat << EOF >> ~/.bash_profile
export ANSIBLE_CONFIG=~/.ansible/ansible.cfg
EOF
fi

source ~/.bash_profile
