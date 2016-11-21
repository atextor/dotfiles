#!/bin/bash

if [ "$(id -u)" != "0" ]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

apt-get install software-properties-common wget
apt-add-repository ppa:ansible/ansible
apt-get update
apt-get install ansible

echo "nocows = 1" >> /etc/ansible/ansible.cfg

[ ! -f playbook.yml ] && wget https://raw.githubusercontent.com/atextor/dotfiles/master/playbook.yml
ansible-playbook --connection=local -i localhost, playbook.yml
