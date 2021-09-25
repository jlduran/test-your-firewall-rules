#!/bin/sh
set -e

jexec lan ping -c 3 192.168.1.1
jexec dmz ping -c 3 192.168.2.1
jexec wan ping -c 3 192.0.2.2 || true
