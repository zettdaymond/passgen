QT += qml quick quickcontrols2

CONFIG += c++11

SOURCES += main.cpp \
    whirlpoolhash.cpp \
    hash/whirlpool.c \
    hash/whirlpool_sbox.c \
    hash/byte_order.c \
    clipboard.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    whirlpoolhash.h \
    hash/whirlpool.h \
    hash/byte_order.h \
    hash/ustd.h \
    clipboard.h
