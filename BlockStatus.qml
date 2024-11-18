import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

RowLayout {
    property string text
    property var model
    property var colors
    property bool isSystem: false

    spacing: 16

    Label {
        text: parent.text
    }

    Repeater {
        model: parent.model
        delegate: Rectangle {
            Layout.fillWidth: !parent.isSystem
            width: parent.isSystem ? 16 : undefined
            height: parent.isSystem ? 16 : 8
            color: parent.colors[modelData]
            radius: 10
        }
    }
}
