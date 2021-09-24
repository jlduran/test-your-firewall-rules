#!/bin/sh
set -e

jexec firewall tcpdump -c 8 -ennlSvvXX
