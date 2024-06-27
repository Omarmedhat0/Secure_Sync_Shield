import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
    id: homeScreenItem
    width: parent.width
    height: parent.height

    Rectangle {
        id: homeScreen
        color: "black"
        width: parent.width
        height: parent.height
        visible: currentScreen === 0

        Rectangle {
            id: popup
            width: parent.width * 0.8
            height: 60
            color: "#2e4f6b"
            border.color: "white"
            border.width: 2
            radius: 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 20
            y: -100

            Behavior on y {
                NumberAnimation {
                    duration: 10000
                    easing.type: Easing.InOutQuad
                }
            }

            SequentialAnimation on y {
                running: true
                PropertyAnimation {
                    to: 20
                    duration: 10000
                }
            }

            RowLayout {
                anchors.centerIn: parent

                Image {
                    id: carImage
                    source: "qrc:/ui/assets/Diagnosis/icons8-maintenance-50.png" // Ensure the path is correct
                    width: 50
                    height: 50

                    SequentialAnimation on x {
                        loops: Animation.Infinite
                        NumberAnimation { to: -2; duration: 500 }
                        NumberAnimation { to: 2; duration: 500 }
                        NumberAnimation { to: 0; duration: 500 }
                    }

                    SequentialAnimation on y {
                        loops: Animation.Infinite
                        NumberAnimation { to: -2; duration: 500 }
                        NumberAnimation { to: 2; duration: 500 }
                        NumberAnimation { to: 0; duration: 500 }
                    }
                }

                Text {
                    id: welcomeText
                    text: "Welcome to I-Car Diagnosis Center"
                    color: "white"
                    font.pixelSize: 20
                    anchors.verticalCenter: parent.verticalCenter
                    opacity: 0.0

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 1000
                            easing.type: Easing.InOutQuad
                        }
                    }

                    SequentialAnimation on opacity {
                        running: true
                        PropertyAnimation {
                            to: 1.0
                            duration: 1000
                        }
                    }
                }
            }
        }

        ColumnLayout {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 80

            Rectangle {
                width: 150
                height: 50
                color: "grey"
                border.color: "white"
                border.width: 2
                radius: 10

                Text {
                    anchors.centerIn: parent
                    text: "About"
                    color: "white"
                }

                MouseArea {
                    id: aboutButton
                    anchors.fill: parent
                    onClicked: {
                        // Transition to About screen
                        currentScreen = 1;
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
                width: 150
                height: 50
                color: "grey"
                id: updateStatus
                border.color: "white"
                border.width: 2
                radius: 10

                Text {
                    anchors.centerIn: parent
                    text: "Software Update"
                    color: "white"
                }

                MouseArea {
                    id: updateButton
                    anchors.fill: parent
                    onClicked: {
                        // Placeholder for software update functionality
                        // someIpClient.checkForUpdate();
                        someIpClient.installUpdate();
                        console.log("Software update button pressed");

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
                width: 150
                height: 50
                color: "grey"
                border.color: "white"
                border.width: 2
                radius: 10

                Text {
                    anchors.centerIn: parent
                    text: "Diagnostic Session"
                    color: "white"
                }

                MouseArea {
                    id: diagSessionButton
                    anchors.fill: parent
                    onClicked: {
                        // Transition to Diagnostic Session Home screen
                        currentScreen = 2;
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
        /********************************/
        /*  integerate with backend     */
        Connections {
            target: someIpClient

            // function onUpdateAvailable(message){
            //     updateStatus.Text = message
            //     updateStatus.color = "green"
            // }

            function onInstallResponse(message) {
                updateStatus.children[0].text = message // Reference the Text element inside updateStatus
            }
        }
        /********************************/
    }
}
