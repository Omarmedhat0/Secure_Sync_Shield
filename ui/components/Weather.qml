import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: weatherComponent
    color: "#151515"
    width: 270
    height: 180
    radius: 15
    anchors.top:parent.top
    anchors.right: parent.right
    anchors.topMargin: 120 // Adjusted top margin to position lower
    anchors.rightMargin: 20

    property string currentTime: formatTime(new Date())
    property string currentDate: formatDate(new Date())
    property string weatherType: "sunny" // example value
    property int temperature: 25 // example value
    property string greeting: getGreeting(new Date())

    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: {
            var now = new Date();
            currentTime = formatTime(now);
            currentDate = formatDate(now);
            greeting = getGreeting(now);
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 10

        RowLayout {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            spacing: 10

            Image {
                source: "qrc:/ui/assets/weather/4102326_cloud_sun_sunny_weather_icon .png" // Replace with actual path to your weather images
                width: 48 // Adjusted width
                height: 48 // Adjusted height
                fillMode: Image.PreserveAspectFit
            }

            Text {
                text: temperature + "°C"
                font.pixelSize: 36
                font.weight: Font.Bold
                font.family: "Lato"
                color: "#FFFFFF"
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            text: greeting
            font.pixelSize: 18
            font.weight: Font.Light
            font.family: "Lato"
            color: "#FFFFFF"
        }
    }

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

    function getGreeting(date) {
        var hours = date.getHours();
        if (hours < 12) {
            return "Good Morning";
        } else if (hours < 18) {
            return "Good Afternoon";
        } else {
            return "Good Evening";
        }
    }
}
