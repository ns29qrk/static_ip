#!/bin/sh

ip4_network='192.168.100.'
ip4_mask='23'
ip4_router='192.168.100.253'

ip6_network='fd29::'
ip6_mask='16'
#ip6_router='192.168.100.253'


_host=255
if [ -n "$1" ]; then
  _host=${1}
fi

device_name=$(ip a | grep 192.168 | awk '{print $NF}')

sudo cat << EOF | sudo tee /etc/netplan/29q_custom.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ${device_name}:
      dhcp4: false
      dhcp6: true
      addresses: [${ip4_network}${_host}/${ip4_mask}, ${ip6_network}${_host}0/${ip6_mask}]
      routes:
        - to: default
          via: ${ip4_router}
      nameservers:
        addresses: [1.1.1.1, 1.0.0.1, "2606:4700:4700::1111", "2606:4700:4700::1001"]
EOF

sudo netplan apply
