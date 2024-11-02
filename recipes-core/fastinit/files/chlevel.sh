#!/bin/sh

runlevel=$1

case $runlevel in
	1)
		mount -o rw,remount /boot
		cat > /boot/cmdline.txt <<EOF
quiet loglevel=0 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait  logo.nologo net.ifnames=0 modules.load=dwc2,g_serial init=/usr/sbin/fastinit.sh 1
EOF
		reboot -f
		;;
	2)
		mount -o rw,remount /boot
		cat > /boot/cmdline.txt <<EOF
quiet loglevel=0 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait  logo.nologo net.ifnames=0 modules.load=dwc2,g_serial init=/usr/sbin/fastinit.sh 2
EOF
		reboot -f
		;;
	3)
		mount -o rw,remount /boot
		cat > /boot/cmdline.txt <<EOF
dwc_otg.lpm_enable=0 console=serial0,115200 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait  logo.nologo net.ifnames=0 modules.load=dwc2,g_serial earlycon=uart8250,mmio32,0x20215040 init=/usr/sbin/fastinit.sh 3
EOF
		reboot -f
		;;
	5)
		mount -o rw,remount /boot
		cat > /boot/cmdline.txt <<EOF
dwc_otg.lpm_enable=0 console=serial0,115200 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait  logo.nologo net.ifnames=0 modules.load=dwc2,g_serial earlycon=uart8250,mmio32,0x20215040 init=/usr/sbin/fastinit.sh 5
EOF
		reboot -f
		;;
	*)
		echo "Invalid new runlevel"
		;;
esac

