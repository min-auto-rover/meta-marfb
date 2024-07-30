do_deploy:append() {
    echo "dtoverlay=uart1" >> $CONFIG
    echo "dtoverlay=dwc2" >> $CONFIG
#    echo "dtoverlay=uart0" >> $CONFIG
}


