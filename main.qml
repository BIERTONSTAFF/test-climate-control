import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Universal 2.15

ApplicationWindow {
    id: root
    minimumWidth: 800
    minimumHeight: 600
    maximumWidth: 1024
    maximumHeight: 768
    visible: true
    title: "Система управления кондиционированием"
    Universal.theme: internal.isDarkTheme ? Universal.Dark : Universal.Light

    Component.onCompleted: {
        settings.load()
    }

    onClosing: {
        settings.save(internal.currentTUnits, internal.currentPUnits, internal.isDarkTheme)
    }

    Connections {
        target: settings

        function onLoaded(currentTUnit, currentPUnit, isDarkTheme) {
            internal.currentTUnits = currentTUnit;
            internal.currentPUnits = currentPUnit;
            internal.isDarkTheme = isDarkTheme;
        }
    }

    Connections {
        target: system

        function onPowerStatusChanged(s) {
            internal.powerStatus = s
        }

        function onAirFlowDirectionChanged(d) {
            internal.airFlowDirection = d
        }

        function onTemperatureChanged(t) {
            internal.t = t
        }

        function onHumidityChanged(h) {
            internal.h = h
        }

        function onPressureChanged(p) {
            internal.p = p
        }
    }

    QtObject {
        id: internal

        property real          t: 0
        property real          p: 0.0
        property int           h: 0
        property int           currentTUnits: 0
        property int           currentPUnits: 0
        property int           airFlowDirection: 0
        property bool          isDarkTheme: false
        property bool          powerStatus: false
        property var           blockStatus: [1, 1, 0]
        readonly property var  tUnits: ["°C", "°F", "K"]
        readonly property var  pUnits: ["мм.рт.ст.", "Па"]
        readonly property var  airFlowDirections: ["Выдув", "Вдув"]
        readonly property var  blockColors: ["#E74856", "#00CC6A"]

        function convertTUnits(value, units) {
            switch (units) {
                case 1: return (value * 9 / 5) + 32
                case 2: return value + 273.15
                default: return value
            }
        }

        function convertPUnits(value, unit) {
            return unit === 1 ? value * 133.332 : value
        }

        function validateRange(value, min, max) {
            return value && value >= min && value <= max
        }

        function setTheme(index) {
            if (index === 1) {
                Universal.theme = Universal.Dark
            } else {
                Universal.theme = Universal.Light
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        GroupBox {
            Layout.fillWidth: true
            title: "Система"

            ColumnLayout {
                width: parent.width
                spacing: 8

                RowLayout {
                    width: parent.width

                    Label {
                        text: "Питание"
                        font.pixelSize: 16
                    }
                    Item { Layout.fillWidth: true }
                    Switch {
                        property bool initialized: false
                        id: powerSwitch
                        checked: internal.powerStatus
                        Component.onCompleted: initialized = true
                        onCheckedChanged:
                            if (initialized)
                                system.power(checked)
                    }
                }

                RowLayout {
                    width: parent.width

                    Label {
                        text: "Направление подачи воздуха"
                        font.pixelSize: 16
                    }
                    Item { Layout.fillWidth: true }
                    ComboBox {
                        property bool initialized: false
                        model: internal.airFlowDirections
                        currentIndex: internal.airFlowDirection
                        Component.onCompleted: initialized = true
                        onCurrentIndexChanged:
                            if (initialized)
                                system.airFlowDirection(currentIndex)
                    }
                }

                RowLayout {
                    spacing: 16

                    Label {
                        text: "Состояние системы"
                    }
                    Rectangle {
                        width: 16
                        height: 16
                        color: internal.powerStatus ? internal.blockColors[1] : internal.blockColors[0]
                        radius: 10
                    }
                }

                RowLayout {
                    spacing: 16

                    Label {
                        text: "Состояние блоков"
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 8
                        color: internal.blockColors[internal.blockStatus[0]]
                        radius: 10
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 8
                        color: internal.blockColors[internal.blockStatus[1]]
                        radius: 10
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 8
                        color: internal.blockColors[internal.blockStatus[2]]
                        radius: 10
                    }
                }
            }
        }

        GroupBox {
            Layout.fillWidth: true
            title: "Отображение"

            ColumnLayout {
                width: parent.width
                spacing: 8

                RowLayout {
                    Label {
                        text: "Шкала температуры"
                        font.pixelSize: 16
                    }
                    Item { Layout.fillWidth: true }
                    ComboBox {
                        model: internal.tUnits
                        currentIndex: internal.currentTUnits
                        onCurrentIndexChanged: internal.currentTUnits = currentIndex
                    }
                }

                RowLayout {
                    Label {
                        text: "Ед. изм. давления"
                        font.pixelSize: 16
                    }
                    Item { Layout.fillWidth: true }
                    ComboBox {
                        model: internal.pUnits
                        currentIndex: internal.currentPUnits
                        onCurrentIndexChanged: internal.currentPUnits = currentIndex
                    }
                }

                RowLayout {
                    width: parent.width

                    Label {
                        text: "Темная тема"
                        font.pixelSize: 16
                    }
                    Item { Layout.fillWidth: true }
                    Switch {
                        checked: internal.isDarkTheme
                        onCheckedChanged: internal.isDarkTheme = checked
                    }
                }
            }
        }

        GroupBox {
            Layout.fillWidth: true
            title: "Мониторинг"

            GridLayout {
                width: parent.width
                columns: 2
                columnSpacing: 16

                Label {
                    text: "Температура"
                    font.pixelSize: 16
                }
                Label {
                    text: internal.convertTUnits(internal.t,
                          internal.currentTUnits).toFixed(1) +
                          internal.tUnits[internal.currentTUnits]
                    font.bold: true
                    Layout.alignment: Qt.AlignRight
                }

                Label {
                    text: "Влажность"
                    font.pixelSize: 16
                }
                Label {
                    text: internal.h + "%"
                    font.bold: true
                    Layout.alignment: Qt.AlignRight
                }

                Label {
                    text: "Давление"
                    font.pixelSize: 16
                }
                Label {
                    text: internal.convertPUnits(internal.p,
                          internal.currentPUnits).toFixed(1) +
                          internal.pUnits[internal.currentPUnits]
                    font.bold: true
                    Layout.alignment: Qt.AlignRight
                }
            }
        }

        Button {
            text: "Отладка"
            Layout.fillWidth: true
            enabled: powerSwitch.checked

            onClicked: {
                let component = Qt.createComponent("DebugWindow.qml")
                let debugWindow = component.createObject(root, {
                    currentTemp: internal.temperature,
                    currentPressure: internal.pressure,
                    currentHumidity: internal.humidity
                })

                debugWindow.save.connect(function(t, p, h) {
                    if (internal.validateRange(t, -50, 50)) internal.t = parseFloat(t)
                    if (internal.validateRange(h, 0, 100)) internal.h = parseInt(h)
                    if (internal.validateRange(p, 700, 800)) internal.p = parseFloat(p)
                })

                debugWindow.show()
            }
        }
    }
}
