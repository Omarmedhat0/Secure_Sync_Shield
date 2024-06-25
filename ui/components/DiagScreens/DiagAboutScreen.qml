import QtQuick 2.15
import QtQuick.Controls 2.15

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
            anchors.centerIn: parent  // Center the image in the parent (the Rectangle)
            source: "qrc:/ui/assets/Diagnosis/icons8-back-26.png"
            smooth: true
            scale: pressed ? 1.2 : 1.0  // Scale the image up when pressed
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



    // Title
    Text {
        id: title
        text: "About"
        color: "white"
        font.pixelSize: 30
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: aboutBackButton.bottom
        anchors.topMargin: 20
    }

    // Scrollable list of items
    ListView {
        id: listView
        width: parent.width
        height: parent.height - aboutBackButton.height - title.height - 40 // Adjusted height to fit within the screen
        anchors.top: title.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.centerIn: parent.horizontalCenter
        anchors.leftMargin: 100
        anchors.topMargin: 50
        spacing: 10

        model: ListModel {
            ListElement { text: "Name: Secure Sync Shield" }
            ListElement { text: "Software Version: 1.0" }
            ListElement { text: "Model Number: XYZ-123" }
            ListElement { text: "Serial Number: 9876543210" }
            ListElement { text: "Name: Secure Sync Shield" }
            ListElement { text: "Software Version: 1.0" }
            ListElement { text: "Model Number: XYZ-123" }
            ListElement { text: "Serial Number: 9876543210" }
        }

        delegate: Item {
            width: listView.width
            height: 50

            Rectangle {
                width: parent.width * 0.8
                height: 50
                color: "grey"
                border.color: "white"
                border.width: 2
                radius: 10

                Text {
                    anchors.centerIn: parent
                    text: model.text
                    color: "white"
                    font.pixelSize: 20
                }
            }
        }

        // Enable flicking and dragging
        flickableDirection: Flickable.VerticalFlick
        clip: true
        interactive: true
    }
}
