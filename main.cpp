/*!
 * \file main.cpp
 * \brief Главный файл приложения
 *
 * Инициализирует основные компоненты приложения:
 * - Графический интерфейс пользователя
 * - Настройки приложения
 * - Систему управления кондиционированием
 */

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQuickControls2/QQuickStyle>
#include "settings.h"
#include "system.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle("Universal");
    QQmlApplicationEngine engine;
    Settings settings(nullptr, QDir::currentPath() + "/settings.xml");
    System system;

    const QUrl url(QStringLiteral("qrc:/main.qml"));

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);

    engine.rootContext()->setContextProperty("settings", &settings);
    engine.rootContext()->setContextProperty("system", &system);
    engine.load(url);

    emit system.powerStatusChanged(0);
    emit system.airFlowDirectionChanged(0);

    return app.exec();
}
