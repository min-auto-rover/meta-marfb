SUMMARY = "Enable and start serial-getty@ttyGS0 service"
LICENSE = "CLOSED"

SRC_URI = "file://serial-getty-init"

S = "${WORKDIR}"

inherit update-rc.d

INITSCRIPT_NAME = "serial-getty"
INITSCRIPT_PARAMS = "defaults"

do_install() {
    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/serial-getty-init ${D}${sysconfdir}/init.d/serial-getty
}

FILES:${PN} = "${sysconfdir}/init.d"

