SUMMARY = "Vision helloworld program with C++ and Autotools"
LICENSE = "GPL-3.0-or-later"
LIC_FILES_CHKSUM = "file://COPYING;md5=1c76c4cc354acaac30ed4d5eefea7245" 

DEPENDS = " opencv \
    ffmpeg \
    libcamera \
    gstreamer1.0 \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
"

PV = "1.0"

SRC_URI = "file://visionhellocc-${PV}.tar.gz" 
S = "${WORKDIR}/${BP}"

FILES:${PN} = "/usr/bin/visionhellocc"

inherit autotools pkgconfig
