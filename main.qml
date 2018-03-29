import QtQuick 2.9
import QtQuick.Window 2.3
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
            var formats = ["", "big red", "gray small", "red blue cyan medium", "large yellow"]
            count++
            postComment(formats[count % formats.length], "我能吞下玻璃而不傷身體wwwww")
        }
    }

    // =========
    // Functions
    // =========

    function resizeToScreen() {
        /* TODO: use Application.screen in Qt 5.9 */
        window.width = Screen.desktopAvailableWidth
        window.height = Screen.desktopAvailableHeight
    }

    function postComment(fmt, text) {
        var rows = Math.floor(window.height / 36)
        var row = Math.floor(Math.random() * rows) * 36
        var ele = factory.createObject(window, { y: row, text: text })

        // Set format
        var flags = fmt.split(" ")
        var sizes = { small: "small", medium: "medium", big: "large", large: "large" }
        var colors = { white: "white", black: "black", gray: "#9e9e9e", red: "#f44336", pink: "#e91e63", purple: "#9c27b0", indigo: "#3f51b5", green: "#4caf50", blue: "#2196f3", cyan: "#00bcd4", teal: "#009688", yellow: "#ffeb3b", orange: "#ff9800", brown: "#795548" }

        for (var i in flags) {
            if (flags[i] in sizes)
                ele.textSize = sizes[flags[i]]
            else if (flags[i] in colors)
                ele.color = colors[flags[i]]
        }

        ele.show()
    }
}
