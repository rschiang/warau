import QtQuick 2.0
import QtGraphicalEffects 1.0

Text {
    id: self

    // ================
    // Internal members
    // ================

    text: "OwO"
    color: "white"
    font.pointSize: self.textSize === "large" ? 52 :
                    self.textSize === "small" ? 28 : 36

    font.weight: Font.DemiBold
    renderType: Text.NativeRendering
    visible: false

    layer.enabled: true
    layer.effect: DropShadow {
        horizontalOffset: 0
        verticalOffset: 2
        radius: 4
    }

    NumberAnimation {
        id: animation
        target: self
        property: "x"
        duration: 8000
        //easing.type: Easing.InSine

        onStopped: {
            self.visible = false
            self.destroy()
        }
    }

    // ==============
    // Public members
    // ==============

    property string textSize: "medium"

    function show() {
        self.x = parent.width
        self.visible = true
        animation.to = -self.paintedWidth
        animation.start()
    }
}
