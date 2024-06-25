import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "../components"

Item {
    id: topBar
    anchors {
        left: parent.left
        right: parent.right
        top: parent.top
    }
    height: parent.height / 12

    Rectangle {
        id: backgroundRect
        anchors.fill: parent
        color: "#000000" // Original color is black

        // MouseArea to handle pressed and released events
        MouseArea {
            anchors.fill: parent
            onPressed: {
                // Apply a fade effect using PropertyAnimation
                fadeEffect.target = backgroundRect
                fadeEffect.property = "color"
                fadeEffect.from = "#000000" // Original color (black)
                fadeEffect.to = "#2e4f6b" // Fade to color
                fadeEffect.duration = 200 // Duration of the animation
                fadeEffect.running = true
            }

            onReleased: {
                // Reset the color to black when released
                fadeEffect.target = backgroundRect
                fadeEffect.property = "color"
                fadeEffect.from = backgroundRect.color
                fadeEffect.to = "#000000"
                fadeEffect.duration = 200 // Duration of the animation
                fadeEffect.running = true
            }
        }

        // PropertyAnimation for fading effect
        ColorAnimation {
            id: fadeEffect
            easing.type: Easing.InOutQuad // Optional: use easing for smooth transition
            duration: 200 // Duration of the animation
        }

        RowLayout {
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 10
            }
            spacing: 20

            // Bluetooth icon
            Image {
                source: "qrc:/ui/assets/UpperBar/icons8-bluetooth-30.png"
                width: 16
                height: 16
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // Handle Bluetooth icon click
                    }
                }
            }

            // WiFi icon
            Image {
                source: "qrc:/ui/assets/UpperBar/icons8-wifi-32.png"
                width: 16
                height: 16
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // Handle WiFi icon click
                    }
                }
            }

            // 4G icon
            Image {
                source: "qrc:/ui/assets/UpperBar/icons8-4g-24.png"
                width: 16
                height: 16
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // Handle 4G icon click
                    }
                }
            }
        }
    }

    DateTime {
        anchors.right: topBar.right
        anchors.verticalCenter: topBar.verticalCenter
    }
}
