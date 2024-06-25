import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt.labs.settings 1.0
import "DiagScreens"

Item {
    width: parent.width
    height: parent.height

    // Define variables to control current screen
    property int currentScreen: 0 // 0 - Home, 1 - About, 2 - DiagSessionHome, 3 - DiagSessionControl, 4 - Loading, 5 - Done

    // Save currentScreen to persistent storage when changed
    onCurrentScreenChanged: {
        if (initialized) {
            Settings.setValue("currentScreen", currentScreen);
        }
    }

    // Flag to track if the component is initialized
    property bool initialized: false

    // Initialize currentScreen from persistent storage when component is instantiated
    Component.onCompleted: {
        if (!initialized) {
            currentScreen = Settings.value("currentScreen", 0);
            initialized = true;
        }
    }

    // Timer for the delay
    Timer {
        id: delayTimer
        interval: 4000 // 4 seconds
        onTriggered: {
            if (currentScreen === 4) {
                currentScreen = 5; // Transition to Done screen after delay
            }
        }
    }
    // Diagnostic Home Screen
    DiagHomeScreen
    {
        id: homeScreenItem
        visible: currentScreen === 0
    }
    // Diagnostic About Screen
    DiagAboutScreen {
        id: aboutScreenItem
        visible: currentScreen === 1
    }

    // Diagnostic Session Home screen
    DiagSessionHomeScreen {
        visible: currentScreen === 2
        anchors.fill: parent
    }
    // Diagnostic Session Control screen
    DiagSessionControlScreen {
        visible: currentScreen === 3
        anchors.fill: parent
    }

    // Loading screen content
    DiagLoadingScreen {
        visible: currentScreen === 4
        anchors.fill: parent
    }
    // Done screen content
    DiagDoneScreen {
        visible: currentScreen === 5
        anchors.fill: parent
    }

    // Settings object for persistent storage
    Settings {
        id: settings
        category: "Application"
    }
}
