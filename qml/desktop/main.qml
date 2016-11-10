import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Universal 2.0


ApplicationWindow {
    id: window
    visible: true
    width: 450
    height: 200
    title: "Passgen"

    Material.accent: Material.Red
    Material.primary: Material.Red

    Shortcut {
        sequence: "Ctrl+C"
        onActivated: {
            passgenPage.copyPassToClipboard();
            copiedPopup.open();
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        focus: true
        initialItem: PassgenPage {
            id :passgenPage
            focus: true
            anchors.fill: parent
        }
    }


    //misc
    Popup {
        id: aboutDialog
        modal: true
        focus: true
        x: (window.width - width) / 2
        y: (window.height - aboutColumn.height) / 2
        width: Math.min(window.width, window.height) / 3 * 2
        contentHeight: aboutColumn.height

        Column {
            id: aboutColumn
            spacing: 20

            Label {
                text: "About"
                font.bold: true
            }

            Label {
                width: aboutDialog.availableWidth
                text: "Passgen generates unique password based on whirlpool hashed resource name and master key."
                wrapMode: Label.Wrap
                font.pixelSize: 12
            }
        }
    }

    Popup {
        id: copiedPopup
        x: (window.width - width) / 2
        y: 0
        width: Math.min(window.width, window.height) / 2
        contentHeight: copiedPopupContent.height
        Label {
            id : copiedPopupContent
            width: copiedPopup.availableWidth
            text: "Password copied."
            wrapMode: Label.Wrap
            font.pixelSize: 12
        }
        Timer {
            id : copiedShowTime
            interval: 2500 //s
            onTriggered: {
                copiedPopup.close()
            }
        }
        onVisibleChanged: {
            if(visible){
                copiedShowTime.restart();
            }
        }

    }
    Component.onCompleted: {
        //place in the center of the screen
        setX(Screen.width / 2 - width / 2);
        setY(Screen.height / 2 - height / 2);
    }
}
