SUMMARY = "A small image just capable of allowing a device to boot."

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
    ${CORE_IMAGE_EXTRA_INSTALL}"

COMPATIBLE_MACHINE = "^rpi$"

LICENSE = "MIT"

inherit core-image

IMAGE_ROOTFS_SIZE ?= "8192"

