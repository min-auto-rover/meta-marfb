do_install:append() {
    cat <<EOF > ${D}${sysconfdir}/dnsmasq.conf
domain-needed
no-resolv
no-poll
no-hosts
interface=wlan0
address=/#/192.168.1.1
dhcp-range=192.168.1.3,192.168.1.254,12h
dhcp-option=option:router,192.168.1.1
dhcp-option=option:dns-server,192.168.1.1
EOF

}
