QT       += core gui quick qml serialport svg

CONFIG += c++17
CONFIG += console
CONFIG += qmltypes

QML_IMPORT_NAME = com.burjuva.heater
QML_IMPORT_MAJOR_VERSION = 1

SOURCES += \
    main.cpp \
    serialconnection.cpp \
    materialmanager.cpp

HEADERS += \
    serialconnection.h \
    materialmanager.h

QML_FILES += \
    main.qml \
    OnScreenKeyboard.qml

RESOURCES += \
    qml.qrc

qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
