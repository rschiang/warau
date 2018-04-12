import QtQuick 2.9
import QtQuick.Window 2.3
import Qt.labs.platform 1.0
import Qt.WebSockets 1.1
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

    WebSocketServer {
        id: server
        name: "warau"
        listen: true

        onClientConnected: {
            webSocket.onTextMessageReceived.connect(onClientMessageReceived)
            webSocket.onStatusChanged.connect(onClientStatusChanged)
            preferencesWindow.statusText = qsTr("Connected")
            preferencesWindow.hide()
        }

        function onClientMessageReceived(message) {
            var fmt = ''
            var text = message.trim()

            // Match formatting string if available
            var pattern = /^#\[([a-z ]+)\]\s*/i
            var match = pattern.exec(text)
            if (match) {
                fmt = match[1]
                text = text.substring(match[0].length)
            }

            postComment(fmt, text)
        }

        function onClientStatusChanged(status) {
            if (status === WebSocket.Closed) {
                preferencesWindow.statusText = qsTr("Waiting for Connection")
                preferencesWindow.show()
            }
        }
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
                onTriggered: preferencesWindow.show()
            }

            MenuItem {
                text: qsTr("Generate Comment")
                shortcut: StandardKey.New
                role: MenuItem.ApplicationSpecificRole
                onTriggered: postComment(Format.random(), qsTr("I can eat glass and it doesn't hurt me."))
            }
        }
    }

    PreferencesWindow {
        id: preferencesWindow
        socketUrl: server.url
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
