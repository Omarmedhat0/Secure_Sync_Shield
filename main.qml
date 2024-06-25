import QtQuick 2.12
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import "ui/LeftColumn"
import "ui/RightScreen"
import "ui/components"

Window {
    id: root
    width: 800
    height: 480
    visible: true
    title: qsTr("Infotainment")
    color: "yellow"
    flags: Qt.FramelessWindowHint

    property int status: 0 // Home screen

    function handleButtonClick(buttonIndex) {
        status = buttonIndex;
        updateButtonColors();
    }

    function updateButtonColors() {
        // Reset all buttons to original color
        homeScreen.color = "black";
        settingScreen.color = "black";
        navigationScreen.color = "black";
        mediaScreen.color = "black";
        connectScreen.color = "black";

        // Highlight the selected button
        switch (status) {
            case 0:
                homeScreen.color = "#2e4f6b";
                break;
            case 1:
                settingScreen.color = "#2e4f6b";
                break;
            case 2:
                navigationScreen.color = "#2e4f6b";
                break;
            case 3:
                mediaScreen.color = "#2e4f6b";
                break;
            case 4:
                connectScreen.color = "#2e4f6b";
                break;
        }
    }

    LeftColumn {
        id: leftColumn

        ColumnLayout {
            id: buttonLayout
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 15

            Rectangle {
                id: homeScreen
                width: 80
                height: 60
                anchors.horizontalCenter: parent.horizontalCenter
                color: root.status === 0 ? "#2e4f6b" : "black"
                radius: 15
                visible: true

                MouseArea {
                    id: button1MouseArea
                    anchors.fill: parent
                    onClicked: {
                        root.handleButtonClick(0);
                    }
                    onPressed: {
                        homeScreen.width *= 1.1;
                        homeScreen.height *= 1.1;
                    }
                    onReleased: {
                        homeScreen.width /= 1.1;
                        homeScreen.height /= 1.1;
                    }
                }

                Image {
                    id: homeIcon
                    source: "qrc:/ui/assets/icons/Home Icon.svg" // Path to your image
                    z: 1
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                    scale: button1MouseArea.pressed ? 1.5 : 1.0
                    Behavior on scale { NumberAnimation { duration: 150 } }
                }
            }

            Rectangle {
                id: settingScreen
                width: 80
                height: 60
                anchors.horizontalCenter: parent.horizontalCenter
                color: root.status === 1 ? "#2e4f6b" : "black"
                radius: 15
                visible: true

                MouseArea {
                    id: button2MouseArea
                    anchors.fill: parent
                    onClicked: {
                        root.handleButtonClick(1);
                    }
                    onPressed: {
                        settingScreen.width *= 1.1;
                        settingScreen.height *= 1.1;
                    }
                    onReleased: {
                        settingScreen.width /= 1.1;
                        settingScreen.height /= 1.1;
                    }
                }

                Image {
                    id: settingIcon
                    source: "qrc:/ui/assets/icons/Car Settings Icon.svg" // Path to your image
                    z: 1
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                    scale: button2MouseArea.pressed ? 1.5 : 1.0
                    Behavior on scale { NumberAnimation { duration: 150 } }
                }
            }

            Rectangle {
                id: navigationScreen
                width: 80
                height: 60
                anchors.horizontalCenter: parent.horizontalCenter
                color: root.status === 2 ? "#2e4f6b" : "black"
                radius: 15
                visible: true

                MouseArea {
                    id: button3MouseArea
                    anchors.fill: parent
                    onClicked: {
                        root.handleButtonClick(2);
                    }
                    onPressed: {
                        navigationScreen.width *= 1.1;
                        navigationScreen.height *= 1.1;
                    }
                    onReleased: {
                        navigationScreen.width /= 1.1;
                        navigationScreen.height /= 1.1;
                    }
                }

                Image {
                    id: navigationIcon
                    source: "qrc:/ui/assets/icons/Navigation Icon.svg" // Path to your image
                    z: 1
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                    scale: button3MouseArea.pressed ? 1.5 : 1.0
                    Behavior on scale { NumberAnimation { duration: 150 } }
                }
            }

            Rectangle {
                id: mediaScreen
                width: 80
                height: 60
                anchors.horizontalCenter: parent.horizontalCenter
                color: root.status === 3 ? "#2e4f6b" : "black"
                radius: 15
                visible: true

                MouseArea {
                    id: button4MouseArea
                    anchors.fill: parent
                    onClicked: {
                        root.handleButtonClick(3);
                    }
                    onPressed: {
                        mediaScreen.width *= 1.1;
                        mediaScreen.height *= 1.1;
                    }
                    onReleased: {
                        mediaScreen.width /= 1.1;
                        mediaScreen.height /= 1.1;
                    }
                }

                Image {
                    id: mediaIcon
                    source: "qrc:/ui/assets/icons/Media Icon.svg" // Path to your image
                    z: 1
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                    scale: button4MouseArea.pressed ? 1.5 : 1.0
                    Behavior on scale { NumberAnimation { duration: 150 } }
                }
            }

            Rectangle {
                id: connectScreen
                width: 80
                height: 60
                anchors.horizontalCenter: parent.horizontalCenter
                color: root.status === 4 ? "#2e4f6b" : "black"
                radius: 15
                visible: true

                MouseArea {
                    id: button5MouseArea
                    anchors.fill: parent
                    onClicked: {
                        root.handleButtonClick(4);
                    }
                    onPressed: {
                        connectScreen.width *= 1.1;
                        connectScreen.height *= 1.1;
                    }
                    onReleased: {
                        connectScreen.width /= 1.1;
                        connectScreen.height /= 1.1;
                    }
                }

                Image {
                    id: connectIcon
                    source: "qrc:/ui/assets/carIcons/icons8-tesla-64.png" // Path to your image
                    z: 1
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                    scale: button5MouseArea.pressed ? 1.5 : 1.0
                    Behavior on scale { NumberAnimation { duration: 150 } }
                }
            }
        }
    }

    RightScreen {
        id: rightScreen
        anchors {
            left: leftColumn.right
            bottom: parent.bottom
            right: parent.right
        }
        status: root.status
    }
    TopBar
    {
    }

    Component.onCompleted: {
        // Initial setup of button colors
        updateButtonColors();
    }
}
