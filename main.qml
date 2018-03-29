import QtQuick 2.9
import QtQuick.Window 2.3
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

    Timer {
        interval: 2000
        repeat: true
        running: true
        property int count: 0
        onTriggered: {
            postComment(Format.random(), "我能吞下玻璃而不傷身體wwwww")
        }
    }

    // =========
    // Functions
    // =========

    function resizeToScreen() {
        /* TODO: use Application.screen in Qt 5.9 */
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
