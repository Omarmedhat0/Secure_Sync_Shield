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
    color: "black"

    property int status: 0 // Home screen

    function handleButtonClick(buttonIndex) {
        status = buttonIndex
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
                anchors.horizontalCenterOffset: root.status == 0 ? 10 : 0
                color: "black"
                radius: 15
                visible: true

                Behavior on anchors.horizontalCenterOffset {
                    PropertyAnimation {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }

                MouseArea {
                    id: button1MouseArea
                    anchors.fill: parent
                    onClicked: {
                        root.handleButtonClick(0)
                    }
                    onPressed: {
                        homeScreen.width *= 1.1
                        homeScreen.height *= 1.1
                    }
                    onReleased: {
                        homeScreen.width /= 1.1
                        homeScreen.height /= 1.1
                    }
                }

                Image {
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
                anchors.horizontalCenterOffset: root.status == 1 ? 15 : 0
                color: "black"
                radius: 15
                visible: true

                Behavior on anchors.horizontalCenterOffset {
                    PropertyAnimation {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }

                MouseArea {
                    id: button2MouseArea
                    anchors.fill: parent
                    onClicked: {
                        root.handleButtonClick(1)
                    }
                    onPressed: {
                        settingScreen.width *= 1.1
                        settingScreen.height *= 1.1
                    }
                    onReleased: {
                        settingScreen.width /= 1.1
                        settingScreen.height /= 1.1
                    }
                }

                Image {
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
                anchors.horizontalCenterOffset: root.status == 2 ? 15 : 0
                color: "black"
                radius: 15
                visible: true

                Behavior on anchors.horizontalCenterOffset {
                    PropertyAnimation {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }

                MouseArea {
                    id: button3MouseArea
                    anchors.fill: parent
                    onClicked: {
                        root.handleButtonClick(2)
                    }
                    onPressed: {
                        navigationScreen.width *= 1.1
                        navigationScreen.height *= 1.1
                    }
                    onReleased: {
                        navigationScreen.width /= 1.1
                        navigationScreen.height /= 1.1
                    }
                }

                Image {
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
                anchors.horizontalCenterOffset: root.status == 3 ? 15 : 0
                color: "black"
                radius: 15
                visible: true

                Behavior on anchors.horizontalCenterOffset {
                    PropertyAnimation {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }

                MouseArea {
                    id: button4MouseArea
                    anchors.fill: parent
                    onClicked: {
                        root.handleButtonClick(3)
                    }
                    onPressed: {
                        mediaScreen.width *= 1.1
                        mediaScreen.height *= 1.1
                    }
                    onReleased: {
                        mediaScreen.width /= 1.1
                        mediaScreen.height /= 1.1
                    }
                }

                Image {
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
                anchors.horizontalCenterOffset: root.status == 4 ? 15 : 0
                color: "black"
                radius: 15
                visible: true

                Behavior on anchors.horizontalCenterOffset {
                    PropertyAnimation {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }

                MouseArea {
                    id: button5MouseArea
                    anchors.fill: parent
                    onClicked: {
                        root.handleButtonClick(4)
                    }
                    onPressed: {
                        connectScreen.width *= 1.1
                        connectScreen.height *= 1.1
                    }
                    onReleased: {
                        connectScreen.width /= 1.1
                        connectScreen.height /= 1.1
                    }
                }

                Image {
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
            top: parent.top
            left: leftColumn.right
            bottom: parent.bottom
            right: parent.right
        }
        status: root.status
    }
}
