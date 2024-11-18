import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

RowLayout {
    width: parent.width

    property string text
    property bool switchChecked: false
    signal checkedChanged(bool initialized, bool checked)

    Label {
        text: parent.text
        font.pixelSize: 16
    }
    Item { Layout.fillWidth: true }
    Switch {
        property bool initialized: false
        checked: parent.switchChecked
        Component.onCompleted: initialized = true
        onCheckedChanged: parent.checkedChanged(initialized, checked)
    }
}
