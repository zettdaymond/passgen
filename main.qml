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
    property string inverseColor: back.color

    Rectangle {
        id : back
        color: window.color
        anchors.fill: parent
        Text {
            text: qsTr("S4mpl3 T3xt")
            color: "black"
            anchors.centerIn: parent
            transform: Rotation {
                id : rot
            }
        }
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
                    echoMode: TextInput.Password
                    onTextChanged: {
                        updatePass();
                    }

                }
                TextField {
                    id: passwd
                    placeholderText: qsTr("Your password")
                    width: window.width * 0.75
                    readOnly: true
                    horizontalAlignment: TextInput.AlignLeft

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


    function getPasswordCS(str, key) {
        //console.log("str hash :", Logic.whirlpool.hash(str));
        //console.log("str + key : ", str + Logic.whirlpool.hash(key))
        //console.log("str + key hash :", Logic.whirlpool.hash(str + Logic.whirlpool.hash(key)));

        var h = whirlpool_hash.hash(str + whirlpool_hash.hash(key));
        var pass = Logic.charset.apply(h, Logic.charset.alphaNumeric);
        return String.fromCharCode.apply(this, pass);
    }

    function updatePass() {
        //print first pass
        //var h = Logic.whirlpool.hash(resource_id.text);
        //console.log( h );
        //var pass = Logic.getPasswordCS(resource_id.text, master_pass.text);
        //passwd.text = pass.slice(0, passLen);
        //var tup =  Logic.getVars(resource_id.text, master_pass.text);
        //passwd.text = tup.pass.slice(0, passLen);;
        //back.color = '#' + tup.color.toString(16);

        //inverseColor = (0xFFFFFF - tup.color).toString(16);
        //rot.angle = tup.rotate;
        passwd.text = getPasswordCS(resource_id.text, master_pass.text).slice(0, passLen);

    }

}
