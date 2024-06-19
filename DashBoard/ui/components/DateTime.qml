import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    color: "#151515"
    Layout.preferredWidth: 270
    Layout.preferredHeight: 125
    radius: 15

    property string currentTime: formatTime(new Date())
    property string currentDate: formatDate(new Date())

    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: {
            var now = new Date();
            currentTime = formatTime(now);
            currentDate = formatDate(now);
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        Text {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            text: currentTime
            font.pixelSize: 36
            font.weight: Font.Bold
            font.family: "Lato"
            color: "#FFFFFF"
        }
        Text {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            text: currentDate
            font.pixelSize: 14
            font.weight: Font.Light
            font.family: "Lato"
            color: "#FFFFFF"
        }
    }

    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: 50 // Adjust this value to move the rectangle down

    function formatDate(date) {
        var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
        var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        var day = days[date.getDay()];
        var month = months[date.getMonth()];
        var dayOfMonth = date.getDate();
        var year = date.getFullYear();
        return day + ", " + month + " " + dayOfMonth + " " + year;
    }

    function formatTime(date) {
        var hours = date.getHours();
        var minutes = date.getMinutes();
        var seconds = date.getSeconds();
        var ampm = hours >= 12 ? 'PM' : 'AM';
        hours = hours % 12;
        hours = hours ? hours : 12; // Handle midnight
        minutes = minutes < 10 ? '0' + minutes : minutes;
        seconds = seconds < 10 ? '0' + seconds : seconds;
        return hours + ':' + minutes + ':' + seconds + ' ' + ampm;
    }
}
