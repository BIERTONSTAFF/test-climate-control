import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

RowLayout {
    width: parent.width
    property string label
    property string value

    Label {
        text: label
        font.pixelSize: 16
    }
    Item { Layout.fillWidth: true }
    Label {
        text: value
        font.bold: true
    }
}
