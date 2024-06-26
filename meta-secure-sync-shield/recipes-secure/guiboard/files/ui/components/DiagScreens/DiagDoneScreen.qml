import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: doneScreen
    color: "black"
    width: parent.width
    height: parent.height

    //reset Button
    Rectangle {
        width: 50
        height: 50
        color: "#2e4f6b"
        border.color: "white"
        border.width: 2
        radius: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top:parent.verticalCenter
        anchors.topMargin: 50



        Image {
            id: iconImage
            anchors.centerIn: parent  // Center the image in the parent (the Rectangle)
            source: "qrc:/ui/assets/Diagnosis/icons8-sync-32.png"
            smooth: true
            scale: button1.pressed ? 1.2 : 1.0  // Scale the image up when pressed
        }
        MouseArea {
            id: button1
            anchors.fill: parent
            onClicked: {
                // Transition back to Home screen
            }
            onPressed: {
                iconImage.scale = 1.4;  // Scale up the image when pressed
            }
            onReleased: {
                iconImage.scale = 1;  // Restore the image scale when released
            }
        }
    }

    //Done
    Rectangle {
        id: popupRect
        color: "transparent"
        width: 300
        height: 180
        visible: currentScreen === 5

        // Center the pop-up
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 50

        // Scale animation
        NumberAnimation {
            id: scaleAnimation
            target: popupRect
            property: "scale"
            from: 0
            to: 1
            duration: 300
            easing.type: Easing.OutBack // Apply an overshoot easing effect
        }

        Rectangle {
            id: contentRect
            color: "grey"
            width: parent.width
            height: parent.height
            radius: 10
            border.color: "white"
            border.width: 2

            // Column layout for content
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 20


                // Title label
                Text {
                    text: "Diagnostic Session Done!"
                    font.pixelSize: 24
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                // Image
                Image {
                    source: "qrc:/ui/assets/Diagnosis/icons8-pass-50.png"
                    width: 50
                    height: 50
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        // Trigger animation when visible
        Behavior on visible {
            NumberAnimation {
                duration: 300
            }
        }
    }

    // Back button
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
            id: iconImage2
            anchors.centerIn: parent  // Center the image in the parent (the Rectangle)
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
                iconImage2.scale = 1.4;  // Scale up the image when pressed
            }
            onReleased: {
                iconImage2.scale = 1;  // Restore the image scale when released
            }
        }
    }
}
