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
    title: "Управление кондиционированием"
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

        function onBlockStatusChanged(b, s) {
            internal.blockStatus.setProperty(b, "status", s);
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
        property var           blockStatus: ListModel {
            ListElement { status: 0 }
            ListElement { status: 0 }
            ListElement { status: 0 }
        }

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

                SectionSwitch {
                    id: power
                    text: "Питание"
                    switchChecked: internal.powerStatus
                    onCheckedChanged: function(initialized, checked) {
                        if (initialized) {
                            system.power(checked)
                        }
                    }
                }

                SectionSelect {
                    text: "Направление подачи воздуха"
                    selectModel: internal.airFlowDirections
                    selectCurrentIndex: internal.airFlowDirection
                    onIndexChanged: function(initialized, currentIndex) {
                        if (initialized) {
                            system.airFlowDirection(currentIndex)
                        }
                    }
                }

                BlockStatus {
                    text: "Состояние системы"
                    model: [internal.powerStatus ? 1 : 0]
                    colors: internal.blockColors
                    isSystem: true
                }

                BlockStatus {
                    text: "Состояние блоков"
                    model: [
                        internal.blockStatus.get(0).status,
                        internal.blockStatus.get(1).status,
                        internal.blockStatus.get(2).status
                    ]
                    colors: internal.blockColors
                }
            }
        }

        GroupBox {
            Layout.fillWidth: true
            title: "Отображение"

            ColumnLayout {
                width: parent.width
                spacing: 8

                SectionSelect {
                    text: "Шкала температуры"
                    selectModel: internal.tUnits
                    selectCurrentIndex: internal.currentTUnits
                    onIndexChanged: function(initialized, currentIndex) {
                        if (initialized) {
                            internal.currentTUnits = currentIndex
                        }
                    }
                }

                SectionSelect {
                    text: "Ед. изм. давления"
                    selectModel: internal.pUnits
                    selectCurrentIndex: internal.currentPUnits
                    onIndexChanged: function(initialized, currentIndex) {
                        if (initialized) {
                            internal.currentPUnits = currentIndex
                        }
                    }
                }

                SectionSwitch {
                    text: "Темная тема"
                    switchChecked: internal.isDarkTheme
                    onCheckedChanged: function(initialized, checked) {
                        if (initialized) {
                            internal.isDarkTheme = checked
                        }
                    }
                }
            }
        }

        GroupBox {
            Layout.fillWidth: true
            title: "Мониторинг"

            ColumnLayout {
                width: parent.width
                spacing: 8

                Sensor {
                    label: "Температура"
                    value: internal.convertTUnits(internal.t,
                           internal.currentTUnits).toFixed(1) +
                           internal.tUnits[internal.currentTUnits]
                }

                Sensor {
                    label: "Влажность"
                    value: internal.h + "%"
                }

                Sensor {
                    label: "Давление"
                    value: internal.convertPUnits(internal.p,
                           internal.currentPUnits).toFixed(1) +
                           internal.pUnits[internal.currentPUnits]
                }
            }
        }

        Button {
            text: "Отладка"
            Layout.fillWidth: true
            enabled: power.switchChecked

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
