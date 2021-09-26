#!/bin/sh
set -e

jexec lan nc -w 3 192.168.1.1 53 || true
jexec dmz nc -w 3 192.168.2.1 53 || true
jexec wan nc -w 3 192.0.2.2 53 || true
