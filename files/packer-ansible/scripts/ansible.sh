#!/bin/sh

sudo dnf install ansible-core python3-firewall -y
ansible-galaxy collection install ansible.posix