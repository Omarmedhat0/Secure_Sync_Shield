SUMMARY = "Application Qt5 demo using Qt5"
DESCRIPTION = " \
               Application development in Qt5 with QtQuick2 to simple test \
               instalation framework Qt5 \
               "

LICENSE = "CLOSED"

DEPENDS += "qtbase qtdeclarative qtsvg qtlocation  libunistring qtimageformats qtmultimedia qtquickcontrols2 qtquickcontrols cinematicexperience liberation-fonts qtscript qtgraphicaleffects qtvirtualkeyboard" 



SRC_URI = "git://github.com/Omarmedhat0/Secure_Sync_Shield.git;protocol=https;branch=GuiAppBranch"
SRCREV = "d49f39804e5373f5fb4514166a9eec859703a26b"

S = "${WORKDIR}/git"

COMPATIBLE_MACHINE = "raspberrypi3-64"

do_install:append() {
  install -d ${D}/opt/QDashBoard_RPI/bin/
}

# FILES_${PN} += "/opt/QDashBoard_RPI/bin"
# FILES_${PN} += "${libdir}/*"
# FILES_${PN}-dev = "${libdir}/* ${includedir}"
# Which files to include in the QDashBoard_RPIpackage
FILES:${PN} = "/opt/QDashBoard_RPI/* \
           /usr/src/debug/QDashBoard_RPI/* \
           /usr/bin/QDashBoard_RPI \
        "

# Which files to include in the QDashBoard_RPI package
FILES:${PN}-dbg = "/opt/QDashBoard_RPI/.debug* \ "
inherit qmake5
