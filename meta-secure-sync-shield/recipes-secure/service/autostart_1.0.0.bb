SUMMARY = "Auto start service"
DESCRIPTION = " \
               Autostart Qt application \
               "
LICENSE = "CLOSED"
inherit systemd
SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN} = "guisock.service"

SRC_URI:append = " file://guisock.service "
FILES:${PN} += "\${systemd_unitdir}/system/guisock.service"

do_install:append() {
  install -d ${D}${systemd_unitdir}/system
  install -m 0644 ${WORKDIR}/guisock.service ${D}${systemd_unitdir}/system
}