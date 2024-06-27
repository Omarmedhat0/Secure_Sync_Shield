QT += quick

CONFIG += c++17

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    BackEnd.cpp \
    main.cpp

HEADERS += \
    BackEnd.h

RESOURCES += qml.qrc

BOOST_INCLUDE_DIR = /usr/include
BOOST_LIB_DIR = /usr/lib/x86_64-linux-gnu
VSOMEIP_INCLUDE_DIR = /home/karim/ITI/somip/install_folder/include
VSOMEIP_LIB_DIR = /home/karim/ITI/somip/install_folder/lib

# Include path for SOME/IP headers
INCLUDEPATH += $$BOOST_INCLUDE_DIR
INCLUDEPATH += $$VSOMEIP_INCLUDE_DIR

# Library path for SOME/IP libraries
LIBS += -L$$VSOMEIP_LIB_DIR -lvsomeip3 \
        -L$$BOOST_LIB_DIR -lboost_system \
        -lboost_thread \
        -lboost_log

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
