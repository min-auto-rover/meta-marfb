FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://myconfig.cfg"

do_configure_prepend() {
    cat ${WORKDIR}/myconfig.cfg >> ${B}/.config
    yes '' | make oldconfig
}

do_clean() {
    kernel_do_clean
    rm -f ${B}/.config
    rm -rf ${B}/modules
}
