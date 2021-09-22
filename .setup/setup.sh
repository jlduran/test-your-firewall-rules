#!/bin/sh
set -e

# create interfaces
outa=$(ifconfig epair create)
ina=$(ifconfig epair create)
out=${outa%a}
in=${ina%a}

# create jails
# lan -- firewall -- wan
jail -c name=firewall persist vnet vnet.interface=${out}a vnet.interface=${in}a
jail -c name=wan persist vnet vnet.interface=${out}b
jail -c name=lan persist vnet vnet.interface=${in}b

# setup wan
jexec wan ifconfig ${out}b ${wan_ifconfig_if0}

# setup firewall
jexec firewall ifconfig ${out}a inet 192.0.2.2/30
jexec firewall ifconfig ${in}a inet 10.0.0.1/24
jexec firewall ifconfig ${out}a name ${firewall_ifconfig_wan_name}
jexec firewall ifconfig ${in}a name ${firewall_ifconfig_lan_name}
jexec firewall sysctl net.inet.ip.forwarding=1
kldload pf
jexec firewall pfctl -e
jexec firewall pfctl -F all -f ${CIRRUS_WORKING_DIR}/pf.conf

# setup lan
jexec lan ifconfig ${in}b ${lan_ifconfig_if0}
jexec lan route add default ${lan_defaultrouter}
