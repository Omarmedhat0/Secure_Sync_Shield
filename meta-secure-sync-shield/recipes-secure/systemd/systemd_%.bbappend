PACKAGECONFIG:append= " networkd resolved"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

MY_INTERFACE = "eth0"

SRC_URI += " \
    file://${MY_INTERFACE}.network \
    file://${MY_INTERFACE}.link \
"

FILES_${PN} += " \
    ${sysconfdir}/systemd/network/${MY_INTERFACE}.network \
    ${sysconfdir}/systemd/network/${MY_INTERFACE}.link \
"

do_install:append() {
    install -d ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/${MY_INTERFACE}.network ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/${MY_INTERFACE}.link ${D}${sysconfdir}/systemd/
}
