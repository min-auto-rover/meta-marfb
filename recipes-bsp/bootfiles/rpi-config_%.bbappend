do_deploy:append() {
    echo "dtoverlay=uart1" >> $CONFIG
    echo "dtoverlay=dwc2" >> $CONFIG
    echo "dtoverlay=vc4-kms-v3d,cma-256" >> $CONFIG
    echo "dtoverlay=ov5647,media-controller=1" >> $CONFIG
#    echo "dtoverlay=uart0" >> $CONFIG
}


