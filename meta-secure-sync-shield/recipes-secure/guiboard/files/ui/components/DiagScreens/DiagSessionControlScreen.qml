import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
Rectangle {
    id: diagSessionControlScreen
    color: "black"
    width: parent.width
    height: parent.height



    // Buttons for Diagnostic Session Control
    ColumnLayout {
        anchors.centerIn:parent

        Rectangle {
            width: 200
            height: 50
            color: "grey"
            border.color: "white"
            border.width: 2
            radius: 10
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                anchors.centerIn: parent
                text: "Chip ID"
                color: "white"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // Placeholder for Chip ID functionality
                    console.log("Chip ID button pressed");
                }
                onPressed: {
                    parent.color = "darkgrey"
                }
                onReleased: {
                    parent.color = "grey"
                }
            }
        }

        Rectangle {
            width: 200
            height: 50
            color: "grey"
            border.color: "white"
            border.width: 2
            radius: 10
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                anchors.centerIn: parent
                text: "Bootloader Version"
                color: "white"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // Placeholder for Bootloader Version functionality
                    console.log("Bootloader Version button pressed");
                }
                onPressed: {
                    parent.color = "darkgrey"
                }
                onReleased: {
                    parent.color = "grey"
                }
            }
        }

        Rectangle {
            width: 200
            height: 50
            color: "grey"
            border.color: "white"
            border.width: 2
            radius: 10
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                anchors.centerIn: parent
                text: "Recovery Mode"
                color: "white"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // Placeholder for Recovery Mode functionality
                    console.log("Recovery Mode button pressed");
                }
                onPressed: {
                    parent.color = "darkgrey"
                }
                onReleased: {
                    parent.color = "grey"
                }
            }
        }

        Rectangle {
            width: 200
            height: 50
            color: "grey"
            border.color: "white"
            border.width: 2
            radius: 10
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                anchors.centerIn: parent
                text: "Install New Update"
                color: "white"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // Transition to Loading screen
                    currentScreen = 4;

                    // Start the delay timer
                    delayTimer.start();
                }
                onPressed: {
                    parent.color = "darkgrey"
                }
                onReleased: {
                    parent.color = "grey"
                }
            }
        }
    }
}
