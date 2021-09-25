#!/bin/sh
set -e

# create interfaces
outa=$(ifconfig epair create)
ina=$(ifconfig epair create)
dmza=$(ifconfig epair create)
out=${outa%a}
in=${ina%a}
dmz=${dmza%a}

# create jails
#           dmz
#            |
# lan -- firewall -- wan
jail -c name=firewall persist vnet vnet.interface=${out}a vnet.interface=${in}a vnet.interface=${dmz}a
jail -c name=wan persist vnet vnet.interface=${out}b
jail -c name=lan persist vnet vnet.interface=${in}b
jail -c name=dmz persist vnet vnet.interface=${dmz}b

# setup wan
jexec wan ifconfig ${out}b ${wan_ifconfig}

# setup firewall
jexec firewall ifconfig ${out}a ${firewall_ifconfig_wan}
jexec firewall ifconfig ${in}a ${firewall_ifconfig_lan}
jexec firewall ifconfig ${dmz}a ${firewall_ifconfig_dmz}
jexec firewall ifconfig ${out}a name ${firewall_ifconfig_wan_name}
jexec firewall ifconfig ${in}a name ${firewall_ifconfig_lan_name}
jexec firewall ifconfig ${dmz}a name ${firewall_ifconfig_dmz_name}
jexec firewall sysctl net.inet.ip.forwarding=1
kldload pf
service pflog onestart
jexec firewall pfctl -e
jexec firewall pfctl -F all -f ${CIRRUS_WORKING_DIR}/pf.conf

# setup lan
jexec lan ifconfig ${in}b ${lan_ifconfig}
jexec lan route add default ${lan_defaultrouter}

# setup dmz
jexec dmz ifconfig ${dmz}b ${dmz_ifconfig}
jexec dmz route add default ${dmz_defaultrouter}
