import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

RowLayout {
    width: parent.width

    property string text
    property var selectModel
    property int selectCurrentIndex: 0
    signal indexChanged(bool initialized, int currentIndex)

    Label {
        text: parent.text
        font.pixelSize: 16
    }
    Item { Layout.fillWidth: true }
    ComboBox {
        property bool initialized: false
        model: parent.selectModel
        currentIndex: parent.selectCurrentIndex
        Component.onCompleted: initialized = true
        onCurrentIndexChanged: parent.indexChanged(initialized, currentIndex)
    }
}
