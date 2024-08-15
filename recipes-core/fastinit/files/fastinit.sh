#!/bin/sh

trap 'exec /sbin/poweroff -f' TERM
trap 'exec /sbin/reboot -f' INT HUP

log_to_kernel() {
	echo "<4>fastinit: $1" > /dev/kmsg
}

warn_to_kernel() {
	echo "<2>fastinit: $1" > /dev/kmsg
}

crit_to_kernel() {
	echo "<1>fastinit: $1" > /dev/kmsg
}

level_zero() {
	exec /sbin/poweroff -f
}

mountfs() {
	log_to_kernel "mounting filesystems"
	mount -t proc proc /proc
	mount -t sysfs sysfs /sys
	mount -o ro /dev/mmcblk0p1 /boot
}

rwrootfs() {
	log_to_kernel "remounting r/w root filesystems"
	mount -o rw,remount /
}

gp23hi() {
	log_to_kernel "setting gpio 23 to high"
	/usr/bin/gpioset -c 0 23=1 &
}

level_one() {
	mountfs
	gp23hi
	crit_to_kernel "host is up and ready"
	log_to_kernel "getting teletypes on ttyS0"
	/sbin/getty -L 115200 ttyS0 vt100
}

level_two() {
	mountfs
	rwrootfs
	log_to_kernel "adding modules to linux kernel"
	log_to_kernel "to be added: bcm2835-codec, bcm2835-isp, bcm2835-v4l2, bcm2835-unicam, ov5647, i2c-mux-pinctrl, i2c-bcm2835, uio, fixed"
	modprobe bcm2835-codec # minors 0-4
	modprobe bcm2835-isp # minors 5-12
	modprobe bcm2835-v4l2
	modprobe bcm2835-unicam # cause red led flash
	modprobe ov5647
	modprobe i2c-mux-pinctrl
	modprobe i2c-bcm2835
	modprobe uio
	modprobe fixed
	udevd --daemon
	udevadm trigger
	gp23hi
	crit_to_kernel "host is up and ready"
	log_to_kernel "getting teletypes on ttyS0"
	/sbin/getty -L 115200 ttyS0 vt100
}

level_five() {
	exec /sbin/init 5
}

level_six() {
	exec /sbin/reboot -f
}

runlevel=$1

if [ -z "$runlevel" ]; then
	warn_to_kernel "cannot read runlevel from argument"
	warn_to_kernel "please edit cmdline.txt in bootfs"
	warn_to_kernel "usage: init=/usr/sbin/fastinit RUNLEVEL"
else
	case $runlevel in
		0)
			log_to_kernel "entering runlevel 0 (halt)"
			level_zero
			;;
		1)
			log_to_kernel "entering runlevel 1 (minimal)"
			log_to_kernel "runlevel 1: tty, serial, gpio"
			level_one
			;;
		2)
			log_to_kernel "entering runlevel 2 (camera)"
			log_to_kernel "runlevel 2: tty, serial, gpio, camera"
			level_two
			;;
		5)
			log_to_kernel "entering runlevel 5 (sysvinit)"
			level_five
			;;
		6)
			log_to_kernel "entering runlevel 6 (reboot)"
			level_six
			;;
		*)
			warn_to_kernel "Runlevel $runlevel not implemented"
			warn_to_kernel "usage: /usr/sbin/fastinit RUNLEVEL"
			;;
	esac
fi

# fastinit has nothing to do when exiting a runlevel, halt
exec /sbin/poweroff -f
