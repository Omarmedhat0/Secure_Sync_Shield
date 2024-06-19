import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import com.example 1.0

Item {
    width: parent.width
    height: parent.height
    anchors.centerIn: parent

    Rectangle {
        color: "white"
        width: parent.width
        height: parent.height

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 20

            Rectangle {
                width: 180
                height: 60
                color: "#252525" // grey
                radius: 15
                Layout.alignment: Qt.AlignHCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        updateManager.checkForUpdate();
                    }
                    onPressed: {
                        parent.width *= 1.1
                        parent.height *= 1.1
                    }
                    onReleased: {
                        parent.width /= 1.1
                        parent.height /= 1.1
                    }
                }

                Text {
                    text: "Check for Update"
                    color: "white"
                    font.pixelSize: 14
                    anchors.centerIn: parent
                }
            }

            Text {
                id: statusText
                text: {
                    if (updateManager.checkStatus === 1)
                        return "Update available";
                    else if (updateManager.checkStatus === -1)
                        return "No updates";
                    else
                        return "";
                }
                color: "black"
                wrapMode: Text.Wrap
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

    UpdateManager {
        id: updateManager
        onCheckStatusChanged: {
            console.log("Check status changed:", updateManager.checkStatus);
        }
    }
}
