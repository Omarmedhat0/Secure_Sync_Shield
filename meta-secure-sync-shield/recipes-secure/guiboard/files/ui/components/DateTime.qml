import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
    id: dateClock
    width: 60
    height: 40
    anchors.right: parent.right
    anchors.rightMargin: 20

    property string currentTime: formatTime(new Date())

    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: {
            currentTime = formatTime(new Date());
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 2 // Adjust spacing as needed

        Text {
            text: currentTime.split(' ')[0] // Time part
            font.pixelSize: 20
            font.weight: Font.Bold
            font.family: "Lato"
            color: "#FFFFFF"
        }

        Text {
            text: currentTime.split(' ')[1] // AM/PM part
            font.pixelSize: 12
            font.weight: Font.Light
            font.family: "Lato"
            color: "#FFFFFF"
        }
    }

    function formatTime(date) {
        var hours = date.getHours();
        var minutes = date.getMinutes();
        var ampm = hours >= 12 ? 'PM' : 'AM';
        hours = hours % 12;
        hours = hours ? hours : 12; // Handle midnight
        var minutesStr = minutes < 10 ? '0' + minutes : minutes;
        return hours + ':' + minutesStr + ' ' + ampm;
    }
}
