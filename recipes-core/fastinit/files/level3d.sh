#!/bin/sh

/usr/bin/gpiomon -c 0 -n 1 -q 24
# blocked until
/sbin/chlevel.sh 3

