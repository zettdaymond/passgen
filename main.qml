import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Universal 2.0


ApplicationWindow {
    id: window
    visible: true
    width: Screen.width
    height: Screen.height
    title: qsTr("Passgen")

    Material.accent: Material.Red
    Material.primary: Material.Red

    header  : ToolBar {
        RowLayout {
            spacing: 20
            anchors.fill: parent

            //dummy
            Label { }

            Label {
                id: titleLabel
                text: "Passgen"
                font.pixelSize: 20
                anchors.rightMargin: 20
                elide: Label.ElideRight
                Layout.fillWidth: true
            }
            ToolButton {
               contentItem: Image {
                   fillMode: Image.Pad
                   horizontalAlignment: Image.AlignHCenter
                   verticalAlignment: Image.AlignVCenter
                   source: "qrc:/assets/copy.png"
               }
               visible: passgenPage.passFieldFocused
               enabled: passgenPage.passFieldFocused
               onClicked: {
                   passgenPage.copyPassToClipboard();
               }
            }

            ToolButton {
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/assets/menu.png"
                }
                onClicked: optionsMenu.open()

                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight

                    MenuItem {
                        text: "About"
                        onTriggered: aboutDialog.open()
                    }
                    MenuItem {
                        text: "Exit"
                        onTriggered: Qt.quit()
                    }
                }
            }

        }
    }
    PassgenPage {
        id :passgenPage
        anchors.fill: parent
    }


    //misc
    Popup {
        id: aboutDialog
        modal: true
        focus: true
        x: (window.width - width) / 2
        y: window.height / 6
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
}
