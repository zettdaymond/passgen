import QtQuick 2.7
import QtQuick.Controls 2.0
import "utils.js" as Logic

Pane {
    id: pane
    property int passLen : 32
    property bool passFieldFocused : false

    Text {
        id : sample_text
        text: qsTr("S4mpl3 T3xt")
        color : "grey"
        scale: 1.7
        anchors.centerIn: parent
        anchors.verticalCenterOffset : -20

        Behavior on color {
            ColorAnimation {
                easing {
                    type: Easing.Linear
                    period: 0.5
                }
            }
        }

        transform: Rotation {
            id : rot
            origin.x : sample_text.width / 2
            origin.y : sample_text.height / 2
            angle: -40
            Behavior on angle {
                RotationAnimation{

                    easing {
                        type: Easing.Linear
                        period: 0.5
                    }
                }
            }
        }
    }

    Grid {
        id: columnLayout1
        anchors.centerIn: parent
        Column {
            TextField {
                id: resource_id
                placeholderText: qsTr("Resource name")
                focus: true
                width: pane.width * 0.75
                onTextChanged: {
                    updatePass();
                }

            }
            TextField {
                id: master_pass
                placeholderText: qsTr("Master pass")
                width: pane.width * 0.75
                echoMode: TextInput.Password
                onTextChanged: {
                    updatePass();
                }

            }
            Row {
                TextField {
                    id: passwd
                    placeholderText: qsTr("Your password")
                    width: pane.width * 0.75
                    readOnly: true
                    horizontalAlignment: TextInput.AlignLeft
                    echoMode : TextInput.Password
                    onFocusChanged: {
                        if(focus) {
                            selectAll();
                            passFieldFocused = true
                        }
                        else {
                            passFieldFocused = false
                        }
                    }
                }
                CheckBox {
                    checked: true
                    onCheckStateChanged: {
                        if(checked) {
                            passwd.echoMode = TextInput.Password
                        }
                        else {
                            passwd.echoMode = TextInput.Normal
                        }
                    }
                }
            }
            Row {
                spacing: 10
                RadioButton {
                    id: char16
                    text: qsTr("16 chars")
                    onClicked: {
                        passLen = 16;
                        updatePass();
                    }
                }
                RadioButton {
                    id: char32
                    text: qsTr("32 chars")
                    checked: true
                    onClicked: {
                        passLen = 32;
                        updatePass();
                    }
                }
            }
        }
    }

    function getPasswordCS(str, key) {
        var h = whirlpool_hash.hash(str + whirlpool_hash.hash(key));
        var pass = Logic.charset.apply(h, Logic.charset.alphaNumeric);
        return String.fromCharCode.apply(this, pass);
    }

    function updatePass() {
        var h = whirlpool_hash.hash(resource_id.text + whirlpool_hash.hash(master_pass.text));
        var pass = Logic.charset.apply(h, Logic.charset.alphaNumeric);
        pass = String.fromCharCode.apply(this, pass);

        var color = h[0]*0xFFFF + h[1]*0xFF +h[2];
        var color_inverse = 0xFFFFFF - color;
        var orientation_angle = ((h[0] / 255.0) - (h[1] / 255.0) + (h[2] / 255.0)) / 2 * 90 * Logic.getsign(h[3]);

        passwd.text = pass.slice(0, passLen);
        rot.angle = orientation_angle;
        sample_text.color = '#' + color.toString(16);

    }
    function copyPassToClipboard() {
        clipboard.postText(passwd.text);
    }
}
