#!/bin/sh

/usr/local/gpiomon -c 0 -n 1 -q 24
# blocked until
/sbin/chlevel.sh 3

