import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3

Window {
    id: window

    // ==========
    // Properties
    // ==========

    visible: false
    flags: Qt.Dialog | Qt.WindowMinimizeButtonHint
    width: 480
    height: 210
    title: "Warau"

    property alias socketUrl: urlLabel.text
    property alias statusText: statusLabel.text

    // ==============
    // Event handlers
    // ==============

    onClosing: function(close) {
        window.hide()
        close.accepted = false
    }

    ColumnLayout {
        anchors.fill: parent

        Text {
            id: urlLabel
            font.pointSize: 36
            text: "ws://"

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 9
        }

        Text {
            id: statusLabel
            font.bold: true
            text: qsTr("Waiting for Connection")

            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
        }

        Text {
            text: qsTr("Channel messages through the WebSocket URL above, and they will appear on screen.")
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
            Layout.margins: 18
        }
    }
}
