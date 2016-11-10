QT += qml quick

CONFIG += c++11

SOURCES += src/main.cpp \
    src/whirlpoolhash.cpp \
    src/hash/whirlpool.c \
    src/hash/whirlpool_sbox.c \
    src/hash/byte_order.c \
    src/clipboard.cpp

android {
    message(Build for android)
    RESOURCES += qml_android.qrc
}
!android {
    message(Build for desktop)
    RESOURCES += qml_desktop.qrc
}


# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    src/whirlpoolhash.h \
    src/hash/whirlpool.h \
    src/hash/byte_order.h \
    src/hash/ustd.h \
    src/clipboard.h

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
