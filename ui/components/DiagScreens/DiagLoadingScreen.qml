import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: loadingScreen
    color: "black"
    width: parent.width
    height: parent.height

    // Rotating image
    Image {
        id: rotatingImage
        anchors.centerIn: parent
        source: "qrc:/ui/assets/Diagnosis/icons8-loading-50.png" // Ensure the path is correct
        RotationAnimation on rotation {
            from: 0
            to: 360
            duration: 1000
            loops: Animation.Infinite
        }
    }
}
