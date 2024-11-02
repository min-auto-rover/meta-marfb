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
	mount -t proc proc /proc
	mount -t sysfs sysfs /sys
	mount -o ro /dev/mmcblk0p1 /boot
	#mount -t tmpfs -o size=100M tmpfs /var/volatile/log
	#mount -t tmpfs -o size=100M tmpfs /var/log
}

rwrootfs() {
	mount -o rw,remount /
}

gp23hi() {
	log_to_kernel "setting gpio 23 to high"
	/usr/bin/gpioset -c 0 23=1 &
}

level_one() {
	log_to_kernel "mounting filesystems"
	mountfs
	gp23hi
	crit_to_kernel "host is up and ready"
	log_to_kernel "getting teletypes on ttyS0"
	/sbin/getty -L 115200 ttyS0 vt100
}

level_two() {
	mountfs
	rwrootfs
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
	/sbin/level3d.sh &
	/usr/bin/marvision 1>/dev/null 2>/dev/null
	# To avoid undefined behaviours when marvision exited abnormally,
	# reboot the system. 
	reboot -f
}

level_three() {
	log_to_kernel "mounting filesystems"
	mountfs
	log_to_kernel "remounting r/w root filesystems"
	rwrootfs
	log_to_kernel "adding modules to linux kernel"
	log_to_kernel "to be added: bcm2835-codec, bcm2835-isp, bcm2835-v4l2, bcm2835-unicam, ov5647, i2c-mux-pinctrl, i2c-bcm2835, uio, fixed, brcmfmac" 
	modprobe bcm2835-codec # minors 0-4
	modprobe bcm2835-isp # minors 5-12
	modprobe bcm2835-v4l2
	modprobe bcm2835-unicam # cause red led flash
	modprobe ov5647
	modprobe i2c-mux-pinctrl
	modprobe i2c-bcm2835
	modprobe uio
	modprobe fixed
	modprobe brcmfmac
	udevd --daemon
	udevadm trigger
	log_to_kernel "setting up lo (127.0.0.1/8)"
	ip addr add 127.0.0.1/8 dev lo
	ip link set lo up
	log_to_kernel "setting up wlan0 (192.168.1.1)"
	ifconfig wlan0 down
	ifconfig wlan0 192.168.1.1
	ifconfig wlan0 up
	log_to_kernel "starting hostapd"
	hostapd /etc/hostapd.conf -B 1>&2
	log_to_kernel "starting dnsmasq"
	dnsmasq 1>&2
	log_to_kernel "starting fcgiwrap"
	fcgiwrap -s unix:/var/run/fcgiwrap.socket &
	log_to_kernel "starting nginx"
	mkdir -p /var/volatile/log
	mkdir -p /var/log/nginx
	mkdir -p /usr/logs
	mkdir -p /run/nginx
	nginx 1>&2
	gp23hi
	crit_to_kernel "host is up and ready"
	log_to_kernel "getting teletypes on ttyS0"
	/sbin/print_motd.sh
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
	crit_to_kernel "cannot read runlevel from argument"
	warn_to_kernel "please edit cmdline.txt in bootfs"
	warn_to_kernel "usage: init=/usr/sbin/fastinit RUNLEVEL"
	crit_to_kernel "triggering kernel panic (c) using sysrq"
	mount -t proc proc /proc
	echo c > /proc/sysrq-trigger
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
			level_two
			;;
		3)
			log_to_kernel "entering runlevel 3 (network)"
			log_to_kernel "runlevel 3: tty, serial, gpio, camera, network, hostap"
			level_three
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
			crit_to_kernel "Runlevel $runlevel not implemented"
			warn_to_kernel "usage: /usr/sbin/fastinit RUNLEVEL"
			crit_to_kernel "triggering kernel panic (c) using sysrq"
			mount -t proc proc /proc
			echo c > /proc/sysrq-trigger
			;;
	esac
fi

# fastinit has nothing to do when exiting a runlevel, halt
exec /sbin/poweroff -f
