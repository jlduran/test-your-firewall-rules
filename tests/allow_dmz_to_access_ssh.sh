#!/bin/sh
set -e

jexec lan nc -w 3 192.168.1.1 22 || true
jexec dmz nc -w 3 192.168.2.1 22
jexec wan nc -w 3 192.0.2.2 22 || true
