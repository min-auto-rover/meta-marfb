SUMMARY = "An image just capable of the MAR project."

IMAGE_INSTALL = "packagegroup-core-boot \
    packagegroup-base-extended \
    python3 \
    python3-pyserial \
    screen \
    usb-modeswitch \
    libgpiod \
    libgpiod-tools \
    fastinit \
    serial-usb \
    v4l-utils \
    libv4l \
    media-ctl \
    opencv \
    ffmpeg \
    libcamera \
    libcamera-dev \
    libcamera-apps \
    gstreamer1.0 \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-plugins-good-rpicamsrc \
    ${CORE_IMAGE_EXTRA_INSTALL}"

COMPATIBLE_MACHINE = "^rpi$"

LICENSE = "MIT"

inherit core-image

IMAGE_ROOTFS_SIZE ?= "8192"

