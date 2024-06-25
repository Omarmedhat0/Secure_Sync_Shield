import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: wifiManagerComponent
    width: 400
    height: 300
    color: "lightgrey"

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        ListView {
            width: parent.width
            height: parent.height - passwordInput.height - 20
            model: wifiModel
            delegate: Rectangle {
                width: parent.width
                height: 40

                Rectangle {
                    width: parent.width
                    height: 40
                    color: "blue"
                    radius: 10
                    border.width: 2
                    border.color: "black"

                    Text {
                        text: ssid
                        anchors.centerIn: parent
                        color: "white"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            passwordInput.visible = true
                            passwordInput.forceActiveFocus()
                            selectedSSID = ssid
                        }
                    }
                }
            }
        }

        RowLayout {
            id: passwordInput
            width: parent.width
            height: 40
            spacing: 10
            visible: false

            TextField {
                id: passwordField
                placeholderText: "Enter WiFi password"
                Layout.fillWidth: true
                echoMode: TextInput.Password
            }

            Button {
                text: "Connect"
                onClicked: {
                    var ssid = selectedSSID
                    var password = passwordField.text

                    // Execute the backend script
                    var process = Qt.createQProcess();
                    process.start("bash", ["-c", "./connect_wifi.sh '" + ssid + "' '" + password + "'"]);
                    process.waitForFinished();

                    // Check the output of the script
                    console.log("Output: ", process.readAllStandardOutput());
                    console.error("Errors: ", process.readAllStandardError());

                    // Reset input fields
                    passwordField.text = ""
                    passwordInput.visible = false
                }
            }
        }
    }

    ListModel {
        id: wifiModel
        Component.onCompleted: {
            updateWifiNetworks()
        }
    }

    property string selectedSSID: ""

    function updateWifiNetworks() {
        wifiModel.clear()

        // Execute a script to get WiFi networks
        var process = Qt.createQProcess();
        process.start("bash", ["-c", "./get_wifi_networks.sh"]);
        process.waitForFinished();

        var output = process.readAllStandardOutput().trim();
        var networks = output.split("\n");

        for (var i = 0; i < networks.length; ++i) {
            var network = networks[i].trim();
            wifiModel.append({ ssid: network });
        }
    }
}
