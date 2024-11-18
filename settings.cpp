/*!
 * \file settings.cpp
 * \brief Файл реализации класса Settings
 */

#include "settings.h"

/*!
 * \brief Конструктор класса Settings
 * \param parent Родительский QObject
 * \param settingsPath Путь к файлу настроек
 *
 * Инициализирует объект Settings и устанавливает путь к файлу настроек
 */

Settings::Settings(QObject *parent, QString settingsPath) : QObject(parent)
{
    this->settingsPath = settingsPath;
}

/*!
 * \brief Сохраняет настройки в XML-файл
 * \param currentTUnit Текущая единица измерения температуры
 * \param currentPUnit Текущая единица измерения давления
 * \param isDarkTheme Флаг темной темы
 *
 * Создает XML-документ с настройками и сохраняет его в файл,
 * указанный в settingsPath
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

    if (file.open(QIODevice::WriteOnly)) {
        QTextStream out(&file);

        document.save(out, 4);
        file.flush();
        file.close();

        qDebug() << "Settings saved on path " << this->settingsPath;
    }
}

/*!
 * \brief Загружает настройки из XML-файла
 *
 * Читает XML-файл настроек и отправляет сигнал loaded()
 * с загруженными значениями. Если файл не существует или
 * не может быть открыт, сигнал не отправляется.
 */

void Settings::load()
{
    QFile file(this->settingsPath);

    if (file.open(QIODevice::ReadOnly)) {
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
}
