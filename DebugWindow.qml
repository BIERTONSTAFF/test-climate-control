import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Window {
    id: debugWindow
    minimumWidth: 300
    minimumHeight: 300
    maximumWidth: 300
    maximumHeight: 300
    title: "Отладка"

    signal save(real t, real p, int h)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16

        property real t
        property real p
        property real h

        TextField {
            id: tInput
            Layout.fillWidth: true
            placeholderText: "Температура"
            validator: DoubleValidator { bottom: -50; top: 50 }
        }

        TextField {
            id: hInput
            Layout.fillWidth: true
            placeholderText: "Влажность"
            validator: IntValidator { bottom: 0; top: 100 }
        }

        TextField {
            id: pInput
            Layout.fillWidth: true
            placeholderText: "Давление"
            validator: DoubleValidator { bottom: 700; top: 800 }
        }

        Button {
            Layout.fillWidth: true
            text: "Сохранить"
            onClicked: {
                save(tInput.text, pInput.text, hInput.text)

                debugWindow.hide()
            }
        }
    }
}
