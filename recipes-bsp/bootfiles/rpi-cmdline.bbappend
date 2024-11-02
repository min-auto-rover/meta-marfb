# enable early console
# https://www.raspberrypi.com/documentation/computers/configuration.html#enabling-early-console-for-linux

#CMDLINE:append = " modules.load=dwc2,g_serial"
#CMDLINE:append = " earlycon=uart8250,mmio32,0x20215040"
#CMDLINE:append = " earlycon=pl011,mmio32,0x20201000"

#CMDLINE:append = " init=/usr/sbin/fastinit.sh 3"

CMDLINE = "quiet loglevel=0 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait  logo.nologo net.ifnames=0 modules.load=dwc2,g_serial init=/usr/sbin/fastinit.sh 2"
