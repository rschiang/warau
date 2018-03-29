import QtQuick 2.0
import QtGraphicalEffects 1.0

Text {
    id: self

    // ================
    // Internal members
    // ================

    text: "OwO"
    color: "white"
    font.pointSize: self.size === "large" ? 52 :
                    self.size === "small" ? 28 : 36

    font.weight: Font.DemiBold
    renderType: Text.NativeRendering
    visible: false

    layer.enabled: true
    layer.effect: DropShadow {
        horizontalOffset: 0
        verticalOffset: 2
        radius: 4
    }

    Timer {
        id: timer
        interval: 6000
        onTriggered: self.hideAndDestroy()
    }

    NumberAnimation {
        id: animation
        target: self
        property: "x"
        duration: 8000
        onStopped: self.hideAndDestroy()
    }

    // ==============
    // Public members
    // ==============

    // property alias text
    // property alias color
    property string size: "medium"
    property string position: "scroll"

    function show() {
        if (self.position === "scroll") {
            self.x = parent.width
            animation.to = -self.paintedWidth
            animation.start()
        } else {
            self.anchors.horizontalCenter = parent.horizontalCenter
            timer.start()
        }

        timeline.register(self)
        self.visible = true
    }

    function hideAndDestroy() {
        self.visible = false
        timeline.unregister(self)
        self.destroy()
    }

    function overlaps(other) {
        return !(self.y > (other.y + other.height) || other.y > (self.y + self.height))
    }
}
