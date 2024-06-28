# Project configuration
QT += quick
CONFIG += c++17

# Uncomment to disable deprecated Qt APIs
# DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000

# Source files
SOURCES += \
    BackEnd.cpp \
    main.cpp

# Header files
HEADERS += \
    BackEnd.h \
    vsomeip/internal/deserializable.hpp \
    vsomeip/internal/logger.hpp \
    vsomeip/internal/policy_manager.hpp \
    vsomeip/internal/serializable.hpp \
    vsomeip/plugins/application_plugin.hpp \
    vsomeip/plugins/pre_configuration_plugin.hpp

# Resource file
RESOURCES += qml.qrc

# Toolchain paths
QMAKE_CC = /opt/poky/4.0.18/sysroots/x86_64-pokysdk-linux/usr/bin/aarch64-poky-linux/aarch64-poky-linux-gcc
QMAKE_CXX = /opt/poky/4.0.18/sysroots/x86_64-pokysdk-linux/usr/bin/aarch64-poky-linux/aarch64-poky-linux-g++
QMAKE_LINK = /opt/poky/4.0.18/sysroots/x86_64-pokysdk-linux/usr/bin/aarch64-poky-linux/aarch64-poky-linux-g++
QMAKE_LFLAGS += --sysroot=/opt/poky/4.0.18/sysroots/cortexa53-poky-linux -L/opt/poky/4.0.18/sysroots/cortexa53-poky-linux/usr/lib

# Include and library directories
QMAKE_LIBDIR += /opt/poky/4.0.18/sysroots/cortexa53-poky-linux/lib
QMAKE_LIBDIR += /opt/poky/4.0.18/sysroots/cortexa53-poky-linux/usr/lib
QMAKE_INCDIR += /opt/poky/4.0.18/sysroots/cortexa53-poky-linux/usr/include

# Paths to Boost and VSOMEIP
BOOST_INCLUDE_DIR = /opt/poky/4.0.18/sysroots/cortexa53-poky-linux/usr/include
BOOST_LIB_DIR = /opt/poky/4.0.18/sysroots/cortexa53-poky-linux/usr/lib
VSOMEIP_INCLUDE_DIR = /home/omar/Downloads/install_folder/include
VSOMEIP_LIB_DIR = /home/omar/Downloads/install_folder/lib

# Include paths for headers
INCLUDEPATH += $$BOOST_INCLUDE_DIR
INCLUDEPATH += $$VSOMEIP_INCLUDE_DIR

# Libraries to link
LIBS += -L$$VSOMEIP_LIB_DIR -lvsomeip3 \
        -L$$BOOST_LIB_DIR -lboost_system \
                          -lboost_thread \
                          -lboost_log

# Deployment rules
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
