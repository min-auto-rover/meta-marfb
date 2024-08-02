SUMMARY = "Installs fast init script to replace SysVinit"
LICENSE = "CLOSED"

SRC_URI = "file://fastinit.sh" 

DEPENDS = "libgpiod"

S = "${WORKDIR}"

do_install() {
    install -d ${D}/usr/sbin
    install -m 0755 ${WORKDIR}/fastinit.sh ${D}/usr/sbin/
}

FILES:${PN} = "/usr/sbin/fastinit.sh"

