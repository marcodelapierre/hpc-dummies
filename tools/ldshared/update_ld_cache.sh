#!/bin/bash

# requires root privileges
echo $(pwd) >>/etc/ld.so.conf.d/libhi.conf
ldconfig
