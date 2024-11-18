/*!
 * \file settings.cpp
 * \brief Файл реализации класса Settings
 */

#include "settings.h"

/*!
 * \brief Инициализирует объект Settings и сохраняет путь к файлу настроек
 */
Settings::Settings(QObject *parent, QString settingsPath) : QObject(parent)
{
    this->settingsPath = settingsPath;
}

/*!
 * \brief Создает XML-документ с настройками и сохраняет его в файл
 *
 * Формирует XML-документ следующей структуры:
 * <settings currentTUnit="" currentPUnit="" isDarkTheme=""/>
 * Сохраняет документ в файл с отступом 4 пробела
 */
void Settings::save(int currentTUnit, int currentPUnit, bool isDarkTheme)
{
    QFile file(this->settingsPath);
    QDomDocument document;
    QDomElement settings(document.createElement("settings"));

    settings.setAttribute("currentTUnit", currentTUnit);
    settings.setAttribute("currentPUnit", currentPUnit);
    settings.setAttribute("isDarkTheme", isDarkTheme);

    document.appendChild(settings);

    if (!file.open(QIODevice::WriteOnly)) {
        qWarning() << "Failed save settings";
        return;
    }

    QTextStream out(&file);
    document.save(out, 4);
    file.close();

    qDebug() << "Settings saved on the path " << this->settingsPath;
}

/*!
 * \brief Читает XML-файл настроек и отправляет сигнал loaded()
 *
 * Открывает файл на чтение, парсит XML и извлекает значения атрибутов.
 * При успешном чтении отправляет сигнал loaded() с прочитанными значениями.
 * При ошибке открытия файла выводит предупреждение.
 */
void Settings::load()
{
    QFile file(this->settingsPath);

    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Failed to load settings";
        return;
    }

    QTextStream in(&file);
    QDomDocument document;
    QDomElement settings;
    int currentTUnit, currentPUnit;
    bool isDarkTheme;

    document.setContent(in.readAll());
    file.close();

    settings = document.firstChildElement();
    currentTUnit = settings.attribute("currentTUnit").toInt();
    currentPUnit = settings.attribute("currentPUnit").toInt();
    isDarkTheme = settings.attribute("isDarkTheme").toInt();

    emit loaded(currentTUnit, currentPUnit, isDarkTheme);

    qDebug() << "Settings loaded successfully";
}
