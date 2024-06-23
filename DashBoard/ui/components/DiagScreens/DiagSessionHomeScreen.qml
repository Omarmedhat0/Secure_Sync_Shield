import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: diagSessionHomeScreen
    color: "black"
    width: parent.width
    height: parent.height


    Rectangle {
        id: aboutScreen
        color: "black"
        width: parent.width
        height: parent.height

        //button
        Rectangle {
            width: 50
            height: 50
            color: "#2e4f6b"
            border.color: "white"
            border.width: 2
            radius: 10
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.left: parent.left

            Image {
                id: iconImage
                anchors.centerIn: parent
                source: "qrc:/ui/assets/Diagnosis/icons8-back-26.png"
                smooth: true
                scale: buttonArea.pressed ? 1.2 : 1.0  // Scale the image up when pressed
            }

            MouseArea {
                id: buttonArea
                anchors.fill: parent
                onClicked: {
                    // Transition back to Home screen
                    currentScreen = 0;
                }
                onPressed: {
                    iconImage.scale = 1.4;  // Scale up the image when pressed
                }
                onReleased: {
                    iconImage.scale = 1;  // Restore the image scale when released
                }
            }
        }
    }

    // Start Diagnostic Session button
    Rectangle {
        width: 200
        height: 50
        color: "grey"
        border.color: "white"
        border.width: 2
        radius: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top:parent.verticalCenter
        anchors.topMargin: 50


        Text {
            anchors.centerIn: parent
            text: "Start Diag Session"
            color: "white"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                // Transition to Diagnostic Session Control screen
                currentScreen = 3;
            }
            onPressed: {
                parent.color = "darkgrey"
            }
            onReleased: {
                parent.color = "grey"
            }
        }
    }

    // Info Text Rectangle
    Rectangle {
        width: 500
        height: 200
        color: "#2e4f6b"
        radius: 10
        border.color: "white"
        border.width: 2
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.horizontalCenter: parent.horizontalCenter


        Text {
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 20
            wrapMode: Text.Wrap
            text: "Turn off the Engine and make sure you have good Internet connection. In case of problems, please contact the official maintenance center for support. Ensure you are privileged to perform this action on this vehicle. Unauthorized access may result in legal consequences according to The Egyptian law."
            color: "white"
            font.pixelSize: 16
            horizontalAlignment: Text.AlignHCenter
        }

        Image {
            id: warningImage
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: text.bottom
            anchors.topMargin: 20
            source: "qrc:/ui/assets/Diagnosis/icons8-warning-80.png"  // Ensure the path is correct
            width: 50
            height: 50
        }
    }
}
