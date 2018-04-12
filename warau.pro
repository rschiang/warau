TEMPLATE = app

QT += qml quick widgets
CONFIG += c++11

SOURCES += src/main.cpp

RESOURCES += qml/qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

# MacOS deployment settings
mac {
    QMAKE_INFO_PLIST = mac/Info.plist
}

DISTFILES +=
