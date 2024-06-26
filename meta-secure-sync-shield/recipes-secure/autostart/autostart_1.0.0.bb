SUMMARY = "Auto start service"
DESCRIPTION = " \
               Autostart Qt application \
               "
LICENSE = "CLOSED"

SRC_URI:append = " file://QDashBoard_RPI.desktop "
FILES:${PN} += "/etc/xdg/autostart/QDashBoard_RPI.desktop"

do_install:append() {
  install -d ${D}/etc/xdg/autostart/
  install -m 0644 ${WORKDIR}/QDashBoard_RPI.desktop ${D}/etc/xdg/autostart/
}
