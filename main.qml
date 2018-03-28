import QtQuick 2.9
import QtQuick.Window 2.3
Window {
    id: window
    visible: true
    color: "#00000000"
    flags: Qt.Window | Qt.FramelessWindowHint | Qt.NoDropShadowWindowHint |
           Qt.WindowStaysOnTopHint | Qt.WindowDoesNotAcceptFocus | Qt.WindowTransparentForInput
    title: qsTr("Warau")

    onVisibilityChanged: resizeToScreen()

    function resizeToScreen() {
        /* TODO: use Application.screen in Qt 5.9 */
        window.width = Screen.desktopAvailableWidth
        window.height = Screen.desktopAvailableHeight
    }

    Component {
        id: factory
        Comment {}
    }

    Timer {
        interval: 2000
        repeat: true
        running: true

        onTriggered: {
            var rows = Math.floor(window.height / 36)
            var row = Math.floor(Math.random() * rows) * 36
            var ele = factory.createObject(window, { y: row, text: "我能吞下玻璃而不傷身體wwwww" })
            ele.show()
        }
    }
}
