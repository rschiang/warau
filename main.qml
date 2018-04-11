import QtQuick 2.9
import QtQuick.Window 2.3
import Qt.labs.platform 1.0
import "format.js" as Format

Window {
    id: window

    // ==========
    // Properties
    // ==========

    visible: true
    color: "#00000000"
    flags: Qt.Window | Qt.FramelessWindowHint | Qt.NoDropShadowWindowHint |
           Qt.WindowStaysOnTopHint | Qt.WindowDoesNotAcceptFocus | Qt.WindowTransparentForInput
    title: qsTr("Warau")

    // ==============
    // Event handlers
    // ==============

    onVisibilityChanged: resizeToScreen()
    onScreenChanged: resizeToScreen()

    // ==========
    // Components
    // ==========

    Timeline {
        id: timeline
    }

    Component {
        id: factory
        Comment {}
    }

    MenuBar {
        id: menuBar
        window: window

        Menu {
            title: qsTr("Application")

            MenuItem {
                text: qsTr("Preferences")
                shortcut: StandardKey.Preferences
                role: MenuItem.PreferencesRole
                onTriggered: console.log("Preferences!")
            }

            MenuItem {
                text: qsTr("Generate Comment")
                shortcut: StandardKey.New
                role: MenuItem.ApplicationSpecificRole
                onTriggered: postComment(Format.random(), qsTr("I can eat glass and it doesn't hurt me."))
            }
        }
    }

    // =========
    // Functions
    // =========

    function resizeToScreen() {
        /* TODO: use Application.screen in Qt 5.9 */
        window.x = 0
        window.y = 0
        window.width = Screen.desktopAvailableWidth
        window.height = Screen.desktopAvailableHeight
        timeline.minY = 12
        timeline.maxY = window.height - 12
    }

    function postComment(fmt, text) {
        var rows = Math.floor(window.height / 36)
        var row = Math.floor(Math.random() * rows) * 36

        var format = Format.parse(fmt)
        format.text = text
        format.y = row

        var ele = factory.createObject(window, format)
        ele.show()
    }
}
