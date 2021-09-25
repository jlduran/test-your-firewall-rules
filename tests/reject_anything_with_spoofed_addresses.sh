#!/bin/sh
set -e

spoof()
{
	jexec "$1" ifconfig lo1 create
	jexec "$1" ifconfig lo1 inet "$2"/24
	jexec "$1" ping -rS "$2" -c 3 "$3" || true
	jexec "$1" ifconfig lo1 destroy
}

spoof "wan" "192.168.1.10" "190.2.0.2"
spoof "lan" "192.168.2.10" "192.168.1.1"
spoof "dmz" "192.168.1.10" "192.168.2.1"
