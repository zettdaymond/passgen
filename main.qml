import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import "whirlpool.js" as Logic

ApplicationWindow {
    id: window
    visible: true
    width: 400
    height: 200
    property alias columnLayout1: columnLayout1
    title: qsTr("Passgen")

    property int passLen

    Rectangle {
        color: window.color
        anchors.fill: parent
        GridLayout {
            id: columnLayout1
            //anchors.horizontalCenter: parent.horizontalCenter
            //anchors.topMargin: 20
            //anchors.top: parent.top
            anchors.centerIn: parent
            //anchors.
            Column {
                TextField {
                    id: resource_id
                    placeholderText: qsTr("Resource name")
                    width: window.width * 0.75
                    onTextChanged: {
                        updatePass();
                    }

                }
                TextField {
                    id: master_pass
                    placeholderText: qsTr("Master pass")
                    width: window.width * 0.75
                    onTextChanged: {
                        updatePass();
                    }

                }
                TextField {
                    id: passwd
                    placeholderText: qsTr("Your password")
                    width: window.width * 0.75
                }
                Row {
                    spacing: 10
                    Button {
                        id: char16
                        text: qsTr("16 chars")
                        onClicked: {
                            passLen = 16;
                            updatePass();
                        }
                    }
                    Button {
                        id: char32
                        text: qsTr("32 chars")
                        onClicked: {
                            passLen = 32;
                            updatePass();
                        }
                    }
                }
            }
        }
    }
    Component.onCompleted: {
        passLen = 32;
    }
    function updatePass() {
        var pass = Logic.getPasswordCS(resource_id.text, master_pass.text);
        passwd.text = pass.slice(0, passLen);
    }
}
