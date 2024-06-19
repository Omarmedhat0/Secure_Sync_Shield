import QtQuick 2.15
import QtLocation 5.2
import QtPositioning 5.2
import QtQuick.Layouts 1.15
import "../components"

Rectangle {
    id: rightScreen
    width: parent.width * 8 / 9
    anchors {
        top: parent.top
        right: parent.right
        bottom: parent.bottom
    }
    color: "black"

    property int status: 0

    Loader {
        id: screenLoader
        anchors.fill: parent
        sourceComponent: {
            switch (root.status) {
                case 0: return homeScreenComponent;
                case 1: return settingScreenComponent;
                case 2: return navigationScreenComponent;
                case 3: return mediaScreenComponent;
                case 4: return connectScreenComponent;
                default: return homeScreenComponent;
            }
        }

        onLoaded: {
            if (item !== currentScreen && item !== null) {
                // Apply fade transition
                if (currentScreen !== null) {
                    fadeOutAnimation.target = currentScreen;
                    fadeOutAnimation.start();
                }
                item.opacity = 0;
                fadeInAnimation.target = item;
                fadeInAnimation.start();
                currentScreen = item;
            }
        }

        Component.onCompleted: {
            currentScreen = homeScreenComponent;
        }
    }

    Component {
        id: homeScreenComponent
        Rectangle {
            color: "black"
            anchors.fill: parent
            DateTime {}
            Weather {
                weatherType: "sunny"
                temperature: 25
            }
        }
    }
    Component {
        id: settingScreenComponent

            Diagnosis
            {
            }
    }


    Component {
        id: navigationScreenComponent
        Rectangle {
            color: "black"
            anchors.fill: parent
            Plugin {
                id: mapPlugin
                name: "osm"
                PluginParameter {
                    name: "osm.mapping.custom.host"
                    value: "https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=jimk46zOm5MkcWeannZ"
                }
                PluginParameter {
                    name: "osm.mapping.custom.subdomains"
                    value: "abc" // Optional: specify subdomains if the tile server supports it
                }
            }

            Map {
                anchors.fill: parent
                plugin: mapPlugin
                center: QtPositioning.coordinate(30.0679221013377, 31.02327624183326) // Centered around Cairo
                zoomLevel: 14
            }

            opacity: 0
        }
    }

    Component {
        id: mediaScreenComponent
        Rectangle {
            color: "yellow"
            anchors.fill: parent
            Text {
                text: "Media Screen"
                anchors.centerIn: parent
                color: "black"
            }
            opacity: 0
        }
    }

    Component {
        id: connectScreenComponent

        Rectangle {
            color: "white"
            width: parent.width
            height: parent.height

            ColumnLayout {
                anchors.fill: parent
                spacing: 10

                // Header with animated image
                Rectangle {
                    width: parent.width
                    height: 200
                    color: "white"
                    border.color: "black"

                    AnimatedImage {
                        source: "qrc:/ui/assets/tesla.gif"
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        z: 1
                    }
                }

                // Scrollable area with text
                Flickable {
                    id: flickable
                    width: parent.width
                    height: parent.height - 200
                    contentWidth: parent.width
                    contentHeight: columnLayout.height
                    clip: true

                    Column {
                        id: columnLayout
                        width: flickable.width
                        spacing: 10
                        padding: 20 // Add padding for better look

                        Rectangle {
                            width: parent.width - 40
                            height: 100
                            color: "white"
                            border.color: "black"
                            Text {
                                anchors.centerIn: parent
                                text: "Model: Tesla Model S"
                                font.pixelSize: 16
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        Rectangle {
                            width: parent.width - 40
                            height: 100
                            color: "white"
                            border.color: "black"
                            Text {
                                anchors.centerIn: parent
                                text: "Name: ITI_44_SSS"
                                font.pixelSize: 16
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        Rectangle {
                            width: parent.width - 40
                            height: 200
                            color: "white"
                            border.color: "black"
                            Text {
                                anchors.centerIn: parent
                                text: "Credits:\nKarim Salah\nOmar Medhat\nAlaa El Gammal\nShaher Shah Abdullah\nMuhamed Ahmed\nFatma Ezzat"
                                font.pixelSize: 16
                                wrapMode: Text.Wrap
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                }
            }

            // Animations for the entire component
            SequentialAnimation {
                id: slideInAnimation
                running: true
                loops: 1

                PropertyAnimation {
                    target: flickable
                    property: "y"
                    from: parent.height
                    to: 200
                    duration: 1000
                    easing.type: Easing.InOutQuad
                }

                PropertyAnimation {
                    target: flickable
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 500
                }
            }
        }
    }



    // Fade animations
    PropertyAnimation {
        id: fadeInAnimation
        target: null
        property: "opacity"
        from: 0
        to: 1
        duration: 500 // 0.5 second
        easing.type: Easing.InOutQuad
    }

    PropertyAnimation {
        id: fadeOutAnimation
        target: null
        property: "opacity"
        to: 0
        duration: 500 // 0.5 second
        easing.type: Easing.InOutQuad
    }

    property Item currentScreen: homeScreenComponent
}
