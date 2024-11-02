SUMMARY = "Installs fast init script to replace SysVinit"
LICENSE = "GPL-3.0-or-later"
LIC_FILES_CHKSUM = "file://COPYING;md5=1c76c4cc354acaac30ed4d5eefea7245"

SRC_URI = "file://fastinit.sh \
    file://print_motd.sh \
    file://chlevel.sh \
    file://level3d.sh \
    file://COPYING"

DEPENDS = "libgpiod"

S = "${WORKDIR}"

do_install() {
    install -d ${D}/usr/sbin
    install -m 0755 ${WORKDIR}/fastinit.sh ${D}/usr/sbin/
    install -m 0755 ${WORKDIR}/print_motd.sh ${D}/usr/sbin/
    install -m 0755 ${WORKDIR}/chlevel.sh ${D}/usr/sbin
    install -m 0755 ${WORKDIR}/level3d.sh ${D}/usr/sbin
}

FILES:${PN} = "/usr/sbin/fastinit.sh /usr/sbin/print_motd.sh /usr/sbin/chlevel.sh /usr/sbin/level3d.sh"

