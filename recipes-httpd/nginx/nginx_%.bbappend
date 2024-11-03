FILESEXTRAPATHS:prepend := "${THISDIR}/nginx:"

SRC_URI += "file://conf/nginx.conf"
SRC_URI += "file://sbin/rtmp-nginx.sh"

SRC_URI += "git://github.com/arut/nginx-rtmp-module.git;protocol=https;name=nginx-rtmp-module;branch=master;tag=v1.2.2;subdir=nginx-rtmp-module"

SRC_URI += "https://github.com/videojs/video.js/releases/download/v8.17.3/video-js-8.17.3.zip;name=videojs;subdir=video-js"
SRC_URI[videojs.sha256sum] = "6aa29b8bd8b0d623d8ee92e752e3d6cdcf2cdff3d25285da12a1b00cdda3d7ea"

SRC_URI += "git://github.com/limithit/NginxExecute.git;protocol=https;name=nginx-exec;branch=master;subdir=nginx-exec;rev=16ee0042ce5757a8111f920d51fe2048c8539aa2"
SRCREV_FORMAT = "sha256"

SRC_URI += "file://html/landing.html"
SRC_URI += "file://html/camctrl.html"
SRC_URI += "file://html/chlevel2.html"
SRC_URI += "file://cgi-bin/camcap.cgi"
SRC_URI += "file://cgi-bin/chlevel2.cgi"

EXTRA_OECONF:append = " --add-module=../nginx-rtmp-module --add-module=../nginx-exec"

do_install:append() {

    # install the modified nginx.conf
    install -m 0644 ${WORKDIR}/conf/nginx.conf ${D}${sysconfdir}/nginx/nginx.conf

    # install cgi-bin folder
    install -m 0755 -d ${D}/var/www/localhost/html/cgi-bin

    # create symlinks, prefix=/usr/local/nginx
    install -m 0644 -d ${D}/usr/local/nginx
    install -m 0644 -d ${D}/usr/local/nginx/conf
    install -m 0644 -d ${D}/usr/local/nginx/sbin
    install -m 0644 -d ${D}/usr/local/nginx/logs
    ln -s /etc/nginx/nginx.conf ${D}/usr/local/nginx/conf/nginx.conf
    ln -s /usr/sbin/nginx ${D}/usr/local/nginx/sbin/nginx
    ln -s /var/www/localhost/html ${D}/usr/local/nginx/
    ln -s /var/volatile/log/nginx/access.log ${D}/usr/local/nginx/logs/access.log
    ln -s /var/volatile/log/nginx/error.log ${D}/usr/local/nginx/logs/error.log

    # install nginx-rtmp-module
    install -m 0666 -d ${D}/usr/local/nginx/nginx-rtmp-module
    cp -r ../nginx-rtmp-module/* ${D}/usr/local/nginx/nginx-rtmp-module/
    cp ${WORKDIR}/sbin/rtmp-nginx.sh ${D}/usr/local/nginx/sbin/
    install -m 0777 -d ${D}/var/www/localhost/html/rtmp
    chown root ${D}/var/www/localhost/html/rtmp
    chown root ${D}/usr/local/nginx/nginx-rtmp-module/stat.xsl
    chmod 0777 ${D}/usr/local/nginx/nginx-rtmp-module/stat.xsl

    # install video.js
    cp -r ${WORKDIR}/video-js/ ${D}/var/www/localhost/html/video-js/

    # install landing page
    cp ${WORKDIR}/html/landing.html ${D}/var/www/localhost/html/index.html
    
    # install camera control
    install -m 0777 -d ${D}/var/www/localhost/html/camctrl
    cp ${WORKDIR}/html/camctrl.html ${D}/var/www/localhost/html/camctrl/index.html
    cp ${WORKDIR}/cgi-bin/camcap.cgi ${D}/var/www/localhost/html/cgi-bin/camcap.cgi
    
    # install change level 2
    install -m 0777 -d ${D}/var/www/localhost/html/chlevel2
    cp ${WORKDIR}/html/chlevel2.html ${D}/var/www/localhost/html/chlevel2/index.html
    cp ${WORKDIR}/cgi-bin/chlevel2.cgi ${D}/var/www/localhost/html/cgi-bin/chlevel2.cgi

}

FILES:${PN} += "/usr/local/ /usr/local/nginx/ /usr/local/nginx/* /var/www/localhost/html/video-js/"
